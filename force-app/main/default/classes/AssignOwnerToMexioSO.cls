public class AssignOwnerToMexioSO
{
    public static void assignOwner(List<Sales_Order__c> lstSO)
    {
        for(Sales_Order__c sobj : lstSO)
        {
            if(sobj.SalesOrgCode__c == '5100' && sobj.CreatedFrom__c == 'SAP')
            {
                sobj.OwnerId = System.Label.MexicoOwner;
            }
        }
    }
    
    public static void assignOwnerPoland(List<Sales_Order__c> lstSO)
    {
        Set<Id> soId = new Set<Id>();
        for(Sales_Order__c sobj : lstSO)
        {
            if(sobj.SalesOrgCode__c == '2941' && sobj.CreatedFrom__c == 'SAP')
            {
                soId.add(sobj.Id);
            }
        }
        List<Sales_Order__c> SOList = [Select Id,Sold_to_Party__r.OwnerId, OwnerId from Sales_Order__c where Id IN:soId];
        if(SOList.size() > 0)
        {
            for(Sales_Order__c soNew : SOList)
            {
                System.debug('Ownerrr==>'+soNew.Sold_to_Party__r.OwnerId);
                soNew.OwnerId = soNew.Sold_to_Party__r.OwnerId;
            }
            update SOList;
        }
    }
}