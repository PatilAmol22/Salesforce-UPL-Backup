public with sharing class consignmentStockController {
    public consignmentStockController() {

    }
    @AuraEnabled
    public static string insertCase2forUPLConsumer(ConsignmentStockWrapper arrayitemList){

        System.debug('arrayitemList------>'+arrayitemList);

        return 'xyz';

    }
   
    
    class ConsignmentStockWrapper {
        @AuraEnabled public String product { get; set; }
        @AuraEnabled public String lote { get; set; }
               @AuraEnabled public Integer quantity { get; set; }
        @AuraEnabled public String uom { get; set; }
               @AuraEnabled public String currenci { get; set; }
        @AuraEnabled public double exchangeRate { get; set; }
               @AuraEnabled public Integer quantitySold { get; set; }
        @AuraEnabled public double netPrice { get; set; }
     @AuraEnabled public String paymentTerm { get; set; }
        @AuraEnabled public String lPNumber { get; set; }
                         
      }
}