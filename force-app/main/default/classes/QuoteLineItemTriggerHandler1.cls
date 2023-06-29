public class QuoteLineItemTriggerHandler1 {

public static void syncQuotes(List<QuoteLineItem> newLineItems)
    {
        System.debug('newLineItems '+newLineItems);
        // get quote ids we need to query for
        Set<Id> quoteIds = new Set<Id>();
        for (QuoteLineItem qli : newLineItems)
        {
            if (qli.QuoteId != null)
            {
                quoteIds.add(qli.QuoteId);
            }
        }

        Integer temp1 =10;
        Integer temp2 =10;
        Integer temp3 =10;
        Integer temp4 =10;
        Integer temp5 =10;
        Integer temp6 =10;
        Integer temp7 =10;
        Integer temp8 =10;
        Integer temp9 =10;
        
        System.debug(' In the test class quoteIds '+quoteIds);
        // Linking quote line item with Opportunity Line Items
        Map<ID,ID> mapQuoteLineItemSortOrder = returnDefaultLinking(quoteIds);
        
        //Fetch opportunity line item for sync
        Map<ID,OpportunityLineItem> mapOppLineItems=new Map<ID,OpportunityLineItem>();
        
        List<OpportunityLineItem> tempList = new List<OpportunityLineItem>(); 
        tempList = [select id, Pack_Size__c,Max_Price__c,Min_Price__c,Storage_Location__c,SKU__c,UOM__c,Sales_Org__c,Division__c,Distribution_Channel__c from OpportunityLineItem where Opportunity.SyncedQuoteId in :quoteIds];
        
        System.debug('Temp List in Test Class Size '+tempList);
        System.debug('Temp List in Test Class Size '+tempList.size());
        
        for(OpportunityLineItem oli:[select id, Pack_Size__c,Max_Price__c,Min_Price__c,Storage_Location__c,UOM__c,Sales_Org__c,SKU__c,Division__c,Distribution_Channel__c from OpportunityLineItem where Opportunity.SyncedQuoteId in :quoteIds])
        {
            mapOppLineItems.put(oli.id,oli);
        }
        
        List<OpportunityLineItem> lstOppotunityToUpdate = new List<OpportunityLineItem>();
        for (QuoteLineItem qli : newLineItems) {
            OpportunityLineItem oli = mapOppLineItems.get(mapQuoteLineItemSortOrder.get(qli.Id));
            if (oli != null ) {
                oli.Pack_Size__c = qli.Pack_Size__c;
                oli.Min_Price__c = qli.Min_Price__c;
                oli.Max_Price__c = qli.Max_Price__c;
                oli.UOM__c = qli.UOM__c;
                oli.Storage_Location__c = qli.Storage_Location__c;
                oli.Distribution_Channel__c = qli.Distribution_Channel__c;
                oli.Sales_Org__c = qli.Sales_Org__c;
                oli.Division__c = qli.Division__c;
                oli.SKU__c = qli.SKU__c;
                
                
                
                //update @@@more fields....
                
                lstOppotunityToUpdate.add(oli);
            }
        }
        
        update lstOppotunityToUpdate;
    }
    private static Map<ID,ID> returnDefaultLinking(Set<ID> poIds)
    {
        Map<ID,ID> mapSortOrder= new Map<ID,ID>();
        //String query='select id, name,(select id, opportunity_line_item_id__c from QuoteLineItems  ) from Quote where id in :poIds';
        String query='select id, name,(select id, opportunity_line_item_id_1__c from QuoteLineItems  ) from Quote where id in :poIds';
        List<Quote> lstQuotesWithLineItems=Database.query(query);
        for(Quote q: lstQuotesWithLineItems)
        {
            if(q.QuoteLineItems !=null)
            {
                for(QuoteLineitem qli : q.QuoteLineItems)
                {
                    if(qli.opportunity_line_item_id_1__c!=null)
                    {
                        //map quote line item id with respective opportunity line item id
                         mapSortOrder.put(qli.Id,ID.valueOF(qli.opportunity_line_item_id_1__c));
                    } 
                }
            }
        }
        return mapSortOrder;
    }
}