/*
* Name: DeleteSalesArea
* Created On: 07 March 2019
* Author: Vishal Pawar (vishal.pawar@skinternational.com)
* Description: Trigger will fire when SaleArea (DistributorSalesAreaMapping__c) deleted.
  it deletes share object records. (Total 6 share object Credit_Info__c,Account_Statement__c,Shipping_Location__c, Outstanding_Ageing__c,Invoice__c,Payments__c(Collection))
    Test Class :- DeleteSalesArea_Test  
*/

trigger DeleteSalesArea on DistributorSalesAreaMapping__c(after delete,after insert,after update) {
    //Added by Aashima(Grazitti) 
    if(Trigger.isAfter && Trigger.isDelete){
         List < DistributorSalesAreaMapping__c > dsaList = new List < DistributorSalesAreaMapping__c > ();
    
    Map < String, DistributorSalesAreaMapping__c > allSalesArea = new Map < String, DistributorSalesAreaMapping__c > ();
    Set<String> accIdSet = new Set<String>();
    Map<String, String> salesAreaMap = new Map<String, String>();
    
    //for Credit_Info__Share
    List<Credit_Info__Share> CreditInfoShareList = new List<Credit_Info__Share>();
    List<Credit_Info__Share> CreditInfoShareListDelete = new List<Credit_Info__Share>();
    
    //for Account Statement
    List < Account_Statement__Share > AccountStatementShareList = new List < Account_Statement__Share > ();
    List < Account_Statement__Share > AccountStatementShareListDelete = new List < Account_Statement__Share > ();
    
    //for Shipping Location
    List < Shipping_Location__Share > ShippingLocationShareList = new List < Shipping_Location__Share > ();
    List < Shipping_Location__Share > ShippingLocationShareListDelete = new List < Shipping_Location__Share > ();
    
    // for Outstanding ageing 
    List < Outstanding_Ageing__Share > OutstandingAgeingShareList = new List < Outstanding_Ageing__Share > ();
    List < Outstanding_Ageing__Share > OutstandingAgeingShareListDelete = new List < Outstanding_Ageing__Share > ();
    
    //for Invoice 
    List < Invoice__Share > InvoiceShareList = new List < Invoice__Share > ();
    List < Invoice__Share > InvoiceShareListDelete = new List < Invoice__Share > ();
    
    //for collection/ payments
    List < Payments__Share > PaymentsShareList = new List < Payments__Share > ();
    List < Payments__Share > PaymentsShareListDelete = new List < Payments__Share > ();
    
    
    
    
    if (Trigger.isDelete) {
        System.debug('trigger calling');
        try{
            dsaList = [SELECT Id, Name, Distributor__c, DistributionChannel__c, Division__c, Status__c, Sales_Org_Code__c,
                       Distribution_Channel_Code__c, Division_Code__c, Company_Code__c, Country_Code__c, Distributor_SAP_Code__c, AccountOwner__c, AccountOwnerActive__c, PriceGroupMaster__c, Order_Type__c, PrIceListTypeMaster__c, Manually_Created__c, Territory__c, Sales_District__c
                       FROM DistributorSalesAreaMapping__c
                       WHERE(Sales_Org_Code__c = '5100'
                             OR Sales_Org_Code__c = '5710')
                       AND Manually_Created__c = True];
            
            System.debug(' dsaList size '+dsaList.size());
            
            if(dsaList.size()>0){
                for (DistributorSalesAreaMapping__c dsaObj: dsaList) {
                    allSalesArea.put(dsaObj.Distributor__c + '-' + dsaObj.AccountOwner__c, dsaObj);
                }
                System.debug(' allSalesArea Size  '+allSalesArea.size());             
            }
            
            for (DistributorSalesAreaMapping__c saObj: Trigger.old) {
                System.debug(' Outside ');
                
                System.debug(' Account Name '+saObj.Distributor__c);            
                System.debug(' Sales Area owner Name '+saObj.AccountOwner__c);            
                if (!allSalesArea.containsKey(saObj.Distributor__c + '-' + saObj.AccountOwner__c)) {
                    System.debug(' only one record ');
                    accIdSet.add(saObj.Distributor__c);
                    salesAreaMap.put(saObj.Distributor__c + '-' + saObj.AccountOwner__c, saObj.AccountOwner__c);
                }else{
                    System.debug(' more than one record ');
                }
                
            }// End Of Trigger.old
            
            System.debug(' accIdSet.size() '+accIdSet.size());
            System.debug(' salesAreaMap.size() '+salesAreaMap.size());
            
            if(accIdSet.size()>0 && salesAreaMap.size()>0){
                //for Credit Info
                System.debug(' accIdSet '+accIdSet);
                System.debug(' salesAreaMap.values() '+salesAreaMap.values());
                
                CreditInfoShareList = [SELECT Id, ParentId, Parent.Distributor__c,UserOrGroupId FROM Credit_Info__Share    
                                       WHERE Parent.Distributor__c IN: accIdSet    
                                       AND UserOrGroupId IN: salesAreaMap.values()
                                       AND RowCause = 'Manual'];
                
                System.debug(' CreditInfoShareList '+CreditInfoShareList.size());
                System.debug(' CreditInfoShareList '+CreditInfoShareList);
                
                if (CreditInfoShareList.size() > 0) {
                    for (Credit_Info__Share CreditInfoShareObj: CreditInfoShareList) {
                        if (salesAreaMap.containsKey(CreditInfoShareObj.Parent.Distributor__c + '-' + CreditInfoShareObj.UserOrGroupId)) {
                            CreditInfoShareListDelete.add(CreditInfoShareObj);
                        }
                    } 
                    System.debug(' Size ofCreditInfoShareListDelete '+CreditInfoShareListDelete.size());
                    
                    System.debug(' CreditInfoShareListDelete '+CreditInfoShareListDelete.size()); 
                    if (CreditInfoShareListDelete.size() > 0) {
                         delete CreditInfoShareListDelete;
                    }
                }   
                
                
                
                //for account statement
                AccountStatementShareList = [SELECT Id, ParentId, Parent.Account__c,UserOrGroupId FROM Account_Statement__Share
                                             WHERE Parent.Account__c IN: accIdSet
                                             AND UserOrGroupId IN: salesAreaMap.values()
                                             AND RowCause = 'Manual'];
                
                if (AccountStatementShareList.size() > 0) {
                    for (Account_Statement__Share AccountStatementShareObj: AccountStatementShareList) {
                        if (salesAreaMap.containsKey(AccountStatementShareObj.Parent.Account__c + '-' + AccountStatementShareObj.UserOrGroupId)) {
                            AccountStatementShareListDelete.add(AccountStatementShareObj);
                        }
                    } // end of for loop
                    System.debug(' AccountStatementShareListDelete '+AccountStatementShareListDelete.size());
                    if (AccountStatementShareListDelete.size() > 0) {
                        delete AccountStatementShareListDelete;
                    }
                }
                
                //for Shipping Location
                ShippingLocationShareList = [SELECT Id, ParentId, Parent.Distributor__c,UserOrGroupId
                                             FROM Shipping_Location__Share
                                             WHERE Parent.Distributor__c IN: accIdSet
                                             AND UserOrGroupId IN: salesAreaMap.values()
                                             AND RowCause = 'Manual'];
                
                if (ShippingLocationShareList.size() > 0) {
                    for (Shipping_Location__Share ShippingLocationShareObj: ShippingLocationShareList) {
                        if (salesAreaMap.containsKey(ShippingLocationShareObj.Parent.Distributor__c + '-' + ShippingLocationShareObj.UserOrGroupId)) {
                            ShippingLocationShareListDelete.add(ShippingLocationShareObj);
                        }
                        
                    }
                     System.debug(' ShippingLocationShareListDelete '+ShippingLocationShareListDelete.size());
                    if (ShippingLocationShareListDelete.size() > 0) {
                        Delete ShippingLocationShareListDelete;
                    }
                }
                
                //for Outstanding ageing
                OutstandingAgeingShareList = [SELECT Id, ParentId, Parent.Customer_Code__c,UserOrGroupId    
                                              FROM Outstanding_Ageing__Share
                                              WHERE Parent.Customer_Code__c IN: accIdSet
                                              AND UserOrGroupId IN: salesAreaMap.values()
                                              AND RowCause = 'Manual'];
                
                
                if (OutstandingAgeingShareList.size() > 0) {
                    for (Outstanding_Ageing__Share OutstandingAgeingShareObj: OutstandingAgeingShareList) {
                        if (salesAreaMap.containsKey(OutstandingAgeingShareObj.Parent.Customer_Code__c + '-' + OutstandingAgeingShareObj.UserOrGroupId)) {
                            OutstandingAgeingShareListDelete.add(OutstandingAgeingShareObj);
                        }
                    }
                      System.debug(' OutstandingAgeingShareListDelete '+OutstandingAgeingShareListDelete.size());
                    if (OutstandingAgeingShareListDelete.size() > 0) {
                         Delete OutstandingAgeingShareListDelete;
                    }
                }
                
                // for Invoice
                InvoiceShareList = [SELECT Id, ParentId, Parent.Sold_To_Party__c,UserOrGroupId
                                    FROM Invoice__Share
                                    WHERE Parent.Sold_To_Party__c IN: accIdSet
                                    AND UserOrGroupId IN: salesAreaMap.values()
                                    AND RowCause = 'Manual'];
                
                
                if (InvoiceShareList.size() > 0) {
                    for (Invoice__Share InvoiceShareObj: InvoiceShareList) {
                        if (salesAreaMap.containsKey(InvoiceShareObj.Parent.Sold_To_Party__c + '-' + InvoiceShareObj.UserOrGroupId)) {
                            InvoiceShareListDelete.add(InvoiceShareObj);
                            
                        }
                    }
                     System.debug(' InvoiceShareListDelete '+InvoiceShareListDelete.size());
                    if (InvoiceShareListDelete.size() > 0) {
                         Delete InvoiceShareListDelete;
                    }
                }
                
                //start of collection / Payments__c
                PaymentsShareList = [SELECT Id, ParentId, Parent.Customer_Name__c,UserOrGroupId
                                     FROM Payments__Share
                                     WHERE Parent.Customer_Name__c IN: accIdSet
                                     AND UserOrGroupId IN: salesAreaMap.values()
                                     AND RowCause = 'Manual'];
                
                
                if (PaymentsShareList.size() > 0) {
                    for (Payments__Share PaymentsShareObj: PaymentsShareList) {
                        if (salesAreaMap.containsKey(PaymentsShareObj.Parent.Customer_Name__c + '-' + PaymentsShareObj.UserOrGroupId)) {
                            PaymentsShareListDelete.add(PaymentsShareObj);
                        }
                    }
                     System.debug(' PaymentsShareListDelete '+PaymentsShareListDelete.size());
                    if (PaymentsShareListDelete.size() > 0) { 
                         Delete PaymentsShareListDelete;
                    }
                }
                
            }
            
            
            
            
        }//End of try
        catch(Exception ex){
            System.debug('Error Occured '+ex.getLineNumber());
            System.debug('Error Message  '+ex.getMessage());
        }
    }
        }
    
    //Added by Aashima(Grazitti) for customer onboarding project starts
        if(Trigger.isAfter && Trigger.isInsert){
            List<String> salesOrgCodeList=System.Label.Grz_IndiaSalesOrgCode.split(',');
            List<Crown_Document__c> cdList=new List<Crown_Document__c>();
            for(DistributorSalesAreaMapping__c sa:Trigger.New){
                if(salesOrgCodeList.contains(sa.Sales_Org_code__c)){
                 Crown_Document__c cd=new Crown_Document__c(Sales_Area__c=sa.Id,Name=sa.Name+' Crown Documents');
                 cdList.add(cd); 
                }
            }
            if(!cdList.isEmpty())
            insert cdList;
        }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('Inside update trigger==>');
        List<DistributorSalesAreaMapping__c> saList=new List<DistributorSalesAreaMapping__c>();
        for(DistributorSalesAreaMapping__c sa:Trigger.New){
            if(sa.Final_Contract_rejected_by_GBS__c==true && sa.Final_Contract_rejected_by_GBS__c!=Trigger.oldMap.get(sa.Id).Final_Contract_rejected_by_GBS__c){
                saList.add(sa);
            }
        }
        System.debug('saList==>'+saList);
        //Called in for loop as it will be per sales area always and never bulkified due to integration being on single record
        if(!saList.isEmpty()){
            for(DistributorSalesAreaMapping__c s:saList){
                Grz_OnboardingCrownIntegration.updateSAPNumber(s.Id,'','Rejected by GBS Team');
            }
        }
    }
    //Added by Aashima(Grazitti) for customer onboarding project ends
    
}