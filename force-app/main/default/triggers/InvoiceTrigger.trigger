/*
* Name: InvoiceTrigger
* Created On: 26 April 2023
* Ticket: RITM0541412
* Owner: Aashima Puri(Grazitti)
*/
trigger InvoiceTrigger on Invoice__c (before insert,before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Invoice__c inv:Trigger.new){
            if(inv.Sales_Org_code__c=='5191' && inv.CurrencyISOCode!='BRL'){
                System.debug('Inside if');
                inv.CurrencyISOCode='BRL';
            }
        }
    }
}