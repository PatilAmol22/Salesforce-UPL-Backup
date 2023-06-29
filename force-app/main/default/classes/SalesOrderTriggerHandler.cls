global class SalesOrderTriggerHandler {
    
    //Trigger execution check variable
    //    public static Boolean runOnce = false;
    //    Code By Aditya&Sirisha @Wipro For US OC-001 Start..
    public static void OrderCancellation(List<Sales_Order__c> newList) {
        Set<string> setBrandName = new Set<string>();
        Set<Id> setOrderId = new Set<Id>();
        List<Sales_Order_Line_Item__c> lstOrderItem = new List<Sales_Order_Line_Item__c>();
        
        for(Sales_Order__c oSO: newList) {
            if((oSO.Order_Status__c == 'Cancelled' ||oSO.Order_Status__c == 'Rejected') && oSO.Type_of_Order__c != 'ORDEM FILHA' && oSO.SalesOrgCode__c == '5191'){
                setOrderId.add(oSO.Id);
            }
        }
        
        if(setOrderId.size() > 0){
            lstOrderItem = [select Id, Sale_Order__c, Quantity__c, Brazil_Product__c, SKU_Name__r.Brand_Name__c, Unbilled_Quatity__c, Quantity_Billed__c, DateofFAT__c, Sale_Order__r.Order_Status__c from Sales_Order_Line_Item__c where Sale_Order__c IN: setOrderId];
            
            if(lstOrderItem.size() > 0){
                for(Sales_Order_Line_Item__c oOrderItem: lstOrderItem){
                    setBrandName.add(oOrderItem.SKU_Name__r.Brand_Name__c);
                }
                
                
                
                Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
                string sBUValue = '5191';
                if(ip1.Sales_Org_BU__c != sBUValue || Test.isRunningTest()) {
                    Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (                                  TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                                    OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                                    
                                                                                                                                                                                                    OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                                    OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                                   ) LIMIT 1];
                    sBUValue = u.Zone_Code__c;
                }
                
                
                list<Inventory_Control__c> fy = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c,Product_Name__c FROM Inventory_Control__c where BU__c =: sBUValue AND  Product__c IN: setBrandName];
                
                list<Inventory_Control__c> lstFYUpdate = new list<Inventory_Control__c>();
                if(fy.size() > 0) {
                    for(Inventory_Control__c oFy: fy) {
                        decimal count = 0;
                        for(Sales_Order_Line_Item__c oItem: lstOrderItem) {
                            
                            //INC0424651-Added by Nandhini to resolve Null pointer Exception
                            if( oItem.DateofFAT__c!=null)
                            {
                                Date d = oItem.DateofFAT__c;
                                string year = string.valueOf(d.year());
                                integer y = integer.valueOf(year.remove('20'));
                                integer month = d.month();
                                string sfy = '';
                                if(month >= 4 && month <= 12){
                                    sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
                                }
                                else if(month >= 1 && month <= 3){
                                    sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
                                }
                                
                                if(oFy.Fiscal_Year__c == sfy && oFy.Product__c == oItem.SKU_Name__r.Brand_Name__c) {
                                    if(oItem.Sale_Order__r.Order_Status__c == 'Rejected' && oItem.Quantity__c != null) { //for RITM0496744 GRZ(Siddhesh) modified date-30-10-2023  
                                        count = count + oItem.Quantity__c;
                                    }
                                    else { 
                                        //for RITM0496744 GRZ(Siddhesh) modified date-30-10-2023 Start
                                        If (oItem.Unbilled_Quatity__c != null){
                                            count = count + oItem.Unbilled_Quatity__c;
                                        }
                                        else{
                                            count = count;
                                        }
                                        //for RITM0496744 GRZ(Siddhesh) modified date-30-10-2023 end
                                    }
                                }
                            }
                        }
                        if(count > 0){
                            oFy.Quantity__c = oFy.Quantity__c + count;
                            lstFYUpdate.add(oFy);
                        }
                        
                    }
                }
                if(lstFYUpdate.size() > 0) {
                    update lstFYUpdate;
                }
            }
        }   
    }
    
    //END
    public static void sharetoTeam(List<Sales_Order__c> newList){
        Set<Id> soldToPartyIds = new Set<Id>();
        Set<Id> soIds = new Set<Id>();
        List<AccountTeamMember> members = new List<AccountTeamMember>();
        Database.SaveResult[] shareInsertResult;
        list<Sales_Order__share> shareList = new list<Sales_Order__share>();
        Map<Id, List<AccountTeamMember>> teamMembersPerAccount = new Map<Id, List<AccountTeamMember>>();
        
        for(Sales_Order__c shareObj: newList){
            // Added by Vijaylaxmi receiving too many SOQL 101
            // below if condition so that SOQL will execute only for below SalesOrg Code
            if(shareObj.SalesOrgCode__c=='5710'|| shareObj.SalesOrgCode__c=='6451'|| shareObj.SalesOrgCode__c=='6410'){
                soIds.add(shareObj.id);
            }
        }
        // Added by Vijaylaxmi receiving too many SOQL 101
        // below if condition so that SOQL will execute only for below SalesOrg Code
        if(soIds.size()>0){
            list<Sales_Order__c> revList = [select id,name,Sold_To_Party__c from Sales_Order__c where id IN:soIds 
                                            AND (SalesOrgCode__c='5710'
                                                 OR SalesOrgCode__c='6451'
                                                 OR SalesOrgCode__c='6410') limit 49999];  
            if(revList!=null && revList.size()>0){
                for(Sales_Order__c soObj:revList ){
                    soldToPartyIds.add(soObj.Sold_To_Party__c);
                }
            }                                    
        }                                    
        if(soldToPartyIds!=null && soldToPartyIds.size()>0) {
            members = [SELECT Id, UserId, AccountId FROM AccountTeamMember WHERE AccountId IN :soldToPartyIds 
                       AND (account.Sales_Org_Code__c='5710'
                            OR account.Sales_Org_Code__c='6451'
                            OR account.Sales_Org_Code__c='6410')  limit 49999];
        }
        //system.debug('**members List-> '+members);
        
        if(members!=null && members.size()>0){
            for(AccountTeamMember member : members){
                if(!teamMembersPerAccount.containsKey(member.AccountId)){
                    system.debug('**Inside If where no team member');
                    teamMembersPerAccount.put(member.AccountId, new List<AccountTeamMember>());
                }
                teamMembersPerAccount.get(member.AccountId).add(member);
            }
        }
        //system.debug('**MAP Made for atm and its member list -> '+teamMembersPerAccount);
        
        if(teamMembersPerAccount!=null && teamMembersPerAccount.size()>0){
            for(Sales_Order__c salesO: newList){
                for(AccountTeamMember atm : teamMembersPerAccount.get(salesO.Sold_To_Party__c)){
                    Sales_Order__share shareSO = new Sales_Order__share();
                    shareSO.ParentId = salesO.Id;
                    shareSO.UserOrGroupId = atm.UserId ;
                    shareSO.AccessLevel = 'Read';
                    shareSO.RowCause = 'Manual';
                    shareList.add(shareSO);
                }
            }
        }
        if(shareList!=null && shareList.size()>0){
            shareInsertResult = Database.insert(shareList,false);
            system.debug('**share result -> ' +shareInsertResult);
        }
    } 
    
    /*
for Maxico CR to update the Notes which appear when Approval will approve the SalesOrder


*/
    public  static void onBeforeUpdate(List<Sales_Order__c> newSalesOrderList){
        
        List<Sales_Order__c> updateSalesOrderList=new List<Sales_Order__c>();
        List<Sales_Order__c> newSalesOrderList2=new List<Sales_Order__c>();
        Set<Id> setIds=new Set<Id>();
        String approvalSatatus;                                                   
        Map<Id,Sales_Order__c> updateSalesOrderMap=new Map<Id,Sales_Order__c>();
        for(Sales_Order__c sOrder: newSalesOrderList)
        {
            if(sOrder.SalesOrgCode__c=='5100' && sOrder.Payment_Term_Days__c>180){
                
                sOrder.Mexico_CFO_CEO_Notes__c=System.Label.Mexico_Approval_Notes_180;             
            }
            System.debug('sOrder.Mexico_CFO_CEO_Notes__c--->'+sOrder.Mexico_CFO_CEO_Notes__c);
            
            if(sOrder.SalesOrgCode__c=='5100' && (sOrder.Approval_Status__c=='Pending@Director'||sOrder.Approval_Status__c=='Pending@ReginalMgr'|| sOrder.Approval_Status__c=='Done' ||sOrder.Approval_Status__c=='Pending@SubRegionHead'))
            {
                System.debug('#####inside first if+sOrder.Approval_Status__c'+sOrder.Approval_Status__c);
                approvalSatatus=sOrder.Approval_Status__c;
                setIds.add(sOrder.Id);
                sOrder.Notes__c='';
                updateSalesOrderMap.put(sOrder.Id, sOrder);
            }
        }
        System.debug('setIds salesOrderID--->'+setIds);
        List<Sales_Order_Line_Item__c> lstSalesOrderLineItems=new List<Sales_Order_Line_Item__c>();
        if(setIds.size()>0){
            
            lstSalesOrderLineItems=[Select Id,MinPrice__c,Sales_Org_Code__c,Net_Price__c,SKU_Code__c,SKU_Name__c,
                                    Manager_Price_Sales_Director_Price__c,Director_Price_Latam_Director_Pri__c,
                                    Sale_Order__c,Sale_Order__r.Approval_Status__c,Sub_Region_Price__c
                                    From 
                                    Sales_Order_Line_Item__c
                                    Where Sale_Order__c=:setIds AND Sales_Org_Code__c='5100'];
        }                             
        for(Sales_Order_Line_Item__c lstOLI:lstSalesOrderLineItems)
        {
            System.debug('####lstOLI.Sale_Order__r.Approval_Status__c'+lstOLI.Sale_Order__r.Approval_Status__c);
            
            if((approvalSatatus=='Pending@ReginalMgr' && lstOLI.Manager_Price_Sales_Director_Price__c>lstOLI.Net_Price__c) || (approvalSatatus=='Pending@Director'&& lstOLI.Net_Price__c<lstOLI.Director_Price_Latam_Director_Pri__c))
            {
                System.debug('#####inside second if+lstOLI.Sale_Order__r.Approval_Status__c'+lstOLI.Sale_Order__r.Approval_Status__c);
                updateSalesOrderMap.get(lstOLI.Sale_Order__c).Notes__c= System.Label.Mexico_Approval_Notes;
            }
            System.debug('Map updated updateSalesOrderMap'+updateSalesOrderMap);
            
            if( (approvalSatatus=='Pending@Director'&& lstOLI.Net_Price__c<lstOLI.Director_Price_Latam_Director_Pri__c))
            {
                System.debug('#####inside director if+lstOLI.Sale_Order__r.Approval_Status__c'+lstOLI.Sale_Order__r.Approval_Status__c);
                updateSalesOrderMap.get(lstOLI.Sale_Order__c).Notes__c= System.Label.Mexico_Approval_Notes;
            }
            System.debug('Map updated updateSalesOrderMap'+updateSalesOrderMap);
            
            if( (approvalSatatus=='Pending@SubRegionHead'&& lstOLI.Net_Price__c<lstOLI.Sub_Region_Price__c))
            {
                System.debug('#####inside Sub_Region_Price__c if+lstOLI.Sale_Order__r.Approval_Status__c'+lstOLI.Sale_Order__r.Approval_Status__c);
                updateSalesOrderMap.get(lstOLI.Sale_Order__c).Notes__c= System.Label.Mexico_Approval_Notes;
            }
            System.debug('Map updated updateSalesOrderMap'+updateSalesOrderMap);    
            
        }
        
        System.debug('updateSalesOrderMap.values()-->'+updateSalesOrderMap.values());
        for(Sales_Order__c sOrder: newSalesOrderList)
        {
            
            if(approvalSatatus=='Done')
            {
                System.debug('#####inside first if+sOrder.Approval_Status__c'+sOrder.Approval_Status__c);
                sOrder.Notes__c='';
            }
            System.debug('sOrder.Notes__c-->'+sOrder.Notes__c);
        }
        
    }
    /*
public  static void onBeforeInsert(List<Sales_Order__c> newSalesOrderLsit){
}

public  static void onBeforeUpdate(List<Sales_Order__c> newSalesOrderLsit, Map<Id,Sales_Order__c> newSalesOrderMap, List<Sales_Order__c> oldSalesOrderList, Map<Id,Sales_Order__c> oldSalesOrderMap){

}

public  static void onBeforeDelete(List<Sales_Order__c> oldSalesOrderList, Map<Id,Sales_Order__c> oldSalesOrderMap){

}

public  static void onAfterInsert(List<Sales_Order__c> newSalesOrderLsit){
for(Sales_Order__c salesOrderRecord : newSalesOrderLsit) {
if(SalesOrderTriggerHelper.duplicateSalesOrderCheck(salesOrderRecord))
System.debug('Duplicate Action Performed');
SalesOrderTriggerHelper.rejectDuplicateOrder(salesOrderRecord);



}

}

public  static void onAfterUpdate(Map<Id,Sales_Order__c> newSalesOrderMap, List<Sales_Order__c> oldSalesOrderList, Map<Id,Sales_Order__c> oldSalesOrderMap){

}

public  static void onAfterDelete(List<Sales_Order__c> oldSalesOrderList, Map<Id,Sales_Order__c> oldSalesOrderMap){

} */

    // added by Sagar@Wipro for SO-013 to update Valid_To__c field in Mother Order
    public static void motherOrderValidToUpdate(List<Sales_Order__c> newList){
        list<Sales_Order__c> motherorder = new list<Sales_Order__c>();
        Mother_Order_Validation__mdt mov = [SELECT id,Number_of_months__c,Active__c from Mother_Order_Validation__mdt where Active__c=true limit 1];
        Database.SaveResult[] insertmotherorder;
        system.debug('mov**'+mov);
        integer noofmonths = integer.valueOf(mov.Number_of_months__c) ;
        system.debug('noofmonths**'+noofmonths);
        for(Sales_Order__c shareObj: newList){
            if(shareObj.Type_of_Order__c  == 'CONTRATO MÃE'){
                shareObj.Valid_To__c =shareObj.Valid_From__c.addMonths(noofmonths);
                motherorder.add(shareObj);
            }
        }
        system.debug('**motherOrders -> ' +motherorder);
    }
    
    // Added for NAM SO owner update GRZ(Nikhil Verma) 20-03-2023
    public static void SalesOrderOwnerUpdateNAM(List<Sales_Order__c> newList){
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> divisionIdSet = new Set<Id>();
        Set<Id> distributionIdSet = new Set<Id>();
        for(Sales_Order__c so : newList){
            if((so.SalesOrgCode__c == '3100' || so.SalesOrgCode__c == '3710') && so.Sold_to_Party__c != null && so.Division_lk__c != null && so.Distribution_Channel_lk__c != null ){
                accIdSet.add(so.Sold_to_Party__c);
                divisionIdSet.add(so.Division_lk__c);
                distributionIdSet.add(so.Distribution_Channel_lk__c);
            }
        }
        if(accIdSet != null && !accIdSet.isEmpty()){
            Map<Id,List<DistributorSalesAreaMapping__c>> mapIdToArea = new Map<Id,List<DistributorSalesAreaMapping__c>>();
            for(DistributorSalesAreaMapping__c dsa : [SELECT Id,AccountOwner__c,Distributor__c,Division__c,DistributionChannel__c,Sales_Org_Code__c FROM DistributorSalesAreaMapping__c 
                                                      WHERE Distributor__c IN:accIdSet AND Division__c IN:divisionIdSet 
                                                      AND DistributionChannel__c IN:distributionIdSet AND AccountOwnerActive__c = true AND Sales_Org_Code__c IN ('3100','3710')]){
                                                          if ( !mapIdToArea.containsKey(dsa.Distributor__c) ) {
                                                              mapIdToArea.put(dsa.Distributor__c , new List<DistributorSalesAreaMapping__c>{dsa});
                                                          } else {
                                                              List<DistributorSalesAreaMapping__c> tempJb = mapIdToArea.get(dsa.Distributor__c);
                                                              tempJb.add(dsa);
                                                              mapIdToArea.put(dsa.Distributor__c , tempJb );
                                                          }
                                                      }
            if(mapIdToArea != null){
                for(Sales_Order__c so : newList){
                    if((so.SalesOrgCode__c == '3100' || so.SalesOrgCode__c == '3710') && so.Sold_to_Party__c != null && so.Division_lk__c != null && so.Distribution_Channel_lk__c != null ){
                        if(mapIdToArea.containsKey(so.Sold_to_Party__c)){
                            for(DistributorSalesAreaMapping__c dsa : mapIdToArea.get(so.Sold_to_Party__c)){
                                if(dsa.Division__c == so.Division_lk__c && dsa.DistributionChannel__c == so.Distribution_Channel_lk__c && dsa.Sales_Org_Code__c == so.SalesOrgCode__c){
                                    so.OwnerId = dsa.AccountOwner__c;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    /*-------------END NAM SO owner update GRZ(Nikhil Verma) 20-03-2023--------*/
    //Added by Nandhini for Error Message capturing
    public static void updateErrorMessage(List<Sales_Order__c> updatedSalesOrderList ,Map<Id,Sales_Order__c> oldSalesOrder){
        set<Id> indiaSalesOrderId =new set<Id>();
        String errorMessage=System.Label.India_Error_Message;
        Map<Id,Set<string>> mapOfErrors=new  Map<Id,Set<string>>();
        for(Sales_Order__c soRec:updatedSalesOrderList){
            if(soRec.Order_Status__c!=oldSalesOrder.get(soRec.Id).Order_Status__c && soRec.Order_Status__c=='Error from SAP'&&String.isNotBlank(soRec.ErrorMessage__c) &&soRec.ErrorMessage__c.containsIgnoreCase(errorMessage) && (soRec.SalesOrgCode__c=='1410' || soRec.SalesOrgCode__c=='1210' || soRec.SalesOrgCode__c=='1510' || soRec.SalesOrgCode__c=='1000')){
                indiaSalesOrderId.add(soRec.Id);
            }
        }
        if(indiaSalesOrderId !=null && !indiaSalesOrderId.isEmpty()){
            List<Transaction_Log__c> transactionRecord=[Select id,Sales_Order__c,Status__c,Message__c from Transaction_Log__c where Status__c='ERROR' AND Sales_Order__c IN: indiaSalesOrderId Order By createddate Desc Limit 5 ];
            system.debug('transactionRecord ::'+transactionRecord);
            for(Transaction_Log__c transRec:transactionRecord){ 
                if(!mapOfErrors.containsKey(transRec.Sales_Order__c)){
                    mapOfErrors.put(transRec.Sales_Order__c,new set<String>());
                    mapOfErrors.get(transRec.Sales_Order__c).add(transRec.Message__c);
                }
                else{
                    mapOfErrors.get(transRec.Sales_Order__c).add(transRec.Message__c);
                }
            }
            system.debug('mapOfErrors :'+mapOfErrors);
            if(mapOfErrors !=null && !mapOfErrors.isEmpty()){
                for(Sales_Order__c soRec:updatedSalesOrderList){
                    Integer i=1;
                    if(indiaSalesOrderId.contains(soRec.Id) && mapOfErrors.containsKey(soRec.Id)){
                        for(String messages :mapOfErrors.get(soRec.Id)){
                            if(i==1){
                                soRec.ErrorMessage__c =i+'. ' +messages;
                            }
                            else{
                                soRec.ErrorMessage__c =soRec.ErrorMessage__c+'\n'+i+'. ' +messages; 
                            }
                            i++;
                            system.debug('soRec.ErrorMessage__c :'+soRec.ErrorMessage__c);
                        }
                    }
                }
            }
        }        
    }
    
    // Added for RITM0459801 GRZ(Mohit Garg) 13-12-2022
    public static void updateCreatedFromField(List<Sales_Order__c> newList){
        Set<Id> soId = new Set<Id>();
        for(Sales_Order__c sobj : newList){
            soId.add(sobj.Id);
        }
        List<Sales_Order__c> SOList = [Select Id, CreatedBy.Profile.Name, OwnerId, Owner.profile.Name from Sales_Order__c where Id IN:soId];
        
        for(Sales_Order__c soNew : SOList){
            if(soNew.CreatedBy.Profile.Name == 'Neebal Integration User'){
                soNew.CreatedFrom__c = 'SAP';
            }
            else{
                soNew.CreatedFrom__c = 'SFDC';
            }
        }
        if(SOList.size() > 0){
            update SOList;
        }  
    }
    /*-------------END RITM0459801 GRZ(Mohit Garg) 13-12-2022--------*/ 
}