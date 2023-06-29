/*
* Name: InvoiceTrigger
* Created On: 26 April 2023
* Ticket: RITM0541412
* Owner: Aashima Puri(Grazitti)
*/
trigger InvoiceLineItemTrigger on Invoice_Line_Item__c (before insert,before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Invoice_Line_Item__c invLI:Trigger.new){
            if(invLI.Sales_Org_code__c=='5191' && invLI.CurrencyISOCode!='BRL'){
                System.debug('Inside if');
                invLI.CurrencyISOCode='BRL';
            }
        }
    }
}