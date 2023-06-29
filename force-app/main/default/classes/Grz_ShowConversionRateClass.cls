/**************************************************************************************************
* Name               : Grz_DisplayConversionRate                                                      
* Description        : Controller class for Grz_ShowConversionRateClass LC Component
* Created Date       : 3/10/2022                                                                 
* Created By         : Swaranjeet (Grazitti)                                                                       
**************************************************************************************************/  
public without sharing class Grz_ShowConversionRateClass {
   
     @AuraEnabled    
    public static  wrapperClassConversion showConversionInfo()
    {
         wrapperClassConversion wapperobj = new wrapperClassConversion();
        try{
             System.debug('in a wrapper----');
       
     	List<CurrencyType> lstCT = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE AND (ISOCode='USD' OR ISOCode='COP') order by ISOCode limit 2];
         System.debug('lstCT--'+lstCT);
        wapperobj.conversionrateCOP = lstCT[0].ConversionRate;
        wapperobj.conversionrateUSD = lstCT[1].ConversionRate;
        wapperobj.ISOcodeCOP = lstCT[0].ISOCode;
        wapperobj.ISOcodeUSD = lstCT[1].ISOCode;
        System.debug('yipee--'+wapperobj);
       
        }
        catch(Exception e){
              System.debug('exception--'+e);
        }
          
         return wapperobj;
        
    }
    
      public class wrapperClassConversion{
        @AuraEnabled public Decimal conversionrateCOP{get;set;}
        @AuraEnabled public Decimal conversionrateUSD{get;set;}
        @AuraEnabled public String ISOcodeCOP{get;set;}
        @AuraEnabled public String ISOcodeUSD{get;set;}
            public wrapperClassConversion(){
            conversionrateCOP = 0.0;
            conversionrateUSD = 0.0;
            ISOcodeCOP = '';
            ISOcodeUSD = '';
      }
}
}