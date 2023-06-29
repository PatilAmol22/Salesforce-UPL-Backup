trigger QuoteLineItemTrigger on QuoteLineItem ( before insert, before update, before delete,
                                                after insert, after update, after delete ) {

    QuoteLineItemTriggerHandler handler = new QuoteLineItemTriggerHandler();

    if ( Trigger.isBefore && Trigger.isInsert ) {
        System.debug('@@@@@  In One');
        handler.handleBeforeInsert( Trigger.new );
    }
    else if ( Trigger.isBefore && Trigger.isUpdate ) {
        System.debug('@@@@@  In Two');
        handler.handleBeforeUpdate( Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap );
        QuoteLineItemTriggerHandler1.syncQuotes(Trigger.new);
    }
    else if ( Trigger.isBefore && Trigger.isDelete ) {
        System.debug('@@@@@ In Three');
        handler.handleBeforeDelete( Trigger.old, Trigger.oldMap );
    }
    else if ( Trigger.isAfter && Trigger.isInsert ) {
        System.debug('@@@@@  In Four');
        handler.handleAfterInsert( Trigger.new, Trigger.newMap ); 
    }
    else if ( Trigger.isAfter && Trigger.isUpdate ) {
        System.debug('@@@@@  In Five');
        handler.handleAfterUpdate( Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap );
    }
    else if ( Trigger.isAfter && Trigger.isDelete ) {
        System.debug('@@@@@  In Six');
        handler.handleAfterDelete( Trigger.old, Trigger.oldMap );
    }

}