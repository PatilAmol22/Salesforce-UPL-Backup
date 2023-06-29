trigger ShippingLocationItaly on Shipping_Location__c (after insert, after update) {
    if(Trigger.isAfter)
    {
        if((Trigger.isInsert || Trigger.isUpdate))
        {
            ShippingLocationItalyHelper.updateOwnerToSL(Trigger.new);
        }
    }
}