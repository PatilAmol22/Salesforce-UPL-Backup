public with sharing class SalesOrderApprovalController {
    
    
    @AuraEnabled
    public static List<Account> fetchAccountDetail(String searchKeyWordAccount) {
        try{
            List<Account>  accList = new List<Account>();
            System.debug('In apex Controller ');
            System.debug('searchKeyWordAccount '+searchKeyWordAccount);
            
            accList =[Select id,Name from Account Where Sales_Org_Code__c='5710' AND Account_Type__c ='Sold To Party' Limit 10];
            System.debug('accList size '+accList.size());
            return accList;
        }
        catch(Exception ex){
            System.debug('Error Message '+ex.getMessage());
            System.debug('Error Message '+ex.getMessage());
            return null;
        }
        
        
    }
    
    
    
    @AuraEnabled
    public static List<User> fetchOwnerNameDetail(String searchKeyWordOwnerName) {
        System.debug('In user List details');
        
        List<User> uList = new List<User>();
        uList =[SELECT Id, Name,Country,Profile.Name FROM User 
                WHERE Country='Colombia' 
                AND IsActive= true 
                AND (Profile.Name='RC (Commercial Representative) NUCO Colombia' OR Profile.Name='PC (Commercial Promoters) NUCO Colombia') LIMIT 10];
        
        if(uList.size()>0){
            return  uList;
        }else{
            return null;    
        }
        
    }
    
    
    
    @AuraEnabled
    public static List<Account> searchHelperOnAccountKeyPres(String searchKeyWordAccount){ 
        String searchKey = '%'+searchKeyWordAccount+'%';
        
        List <Account> returnList = new List <Account> ();
        
        String sQuery = 'SELECT Id, Name FROM Account WHERE Name like \'%'+searchKeyWordAccount+'%\' AND Account_Type__c= \'Sold To Party\' AND Sales_Org_Code__c=\'5710\'  order by Name asc' ;
        
        System.debug('sQuery '+sQuery);
        List <Account> lstOfRecords = Database.query(sQuery);
        
        for (Account obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        
        
        System.debug('returnListin return '+returnList);
        Map<String,Account> accountMap=new Map<String,Account>();
        
        for(Account PD:returnList){
            accountMap.put(PD.Name,PD);
        }
        
        return accountMap.values();
    }
    
    
    
    @AuraEnabled
    public static List<User> searchHelperOnOwnerNameKeyPres(String searchKeyWordOwnerName){
        
        System.debug('searchKeyWordOwnerName '+searchKeyWordOwnerName);
        String searchKey = '%'+searchKeyWordOwnerName+'%';
        
        List <User> returnList = new List <User> ();
        
        String sQuery = 'SELECT Id, Name,Country,Profile.Name  FROM User WHERE Name like \'%'+searchKeyWordOwnerName+'%\' AND Country= \'Colombia\' AND IsActive= true AND (Profile.Name=\'RC (Commercial Representative) NUCO Colombia\' OR Profile.Name=\'PC (Commercial Promoters) NUCO Colombia\') order by Name asc' ;
        
        System.debug('sQuery '+sQuery);
        List <User> lstOfRecords = Database.query(sQuery);
        
        for (User obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        
        
        System.debug('returnListin return '+returnList);
        Map<String,User> userMap=new Map<String,User>();
        
        for(User PD:returnList){
            userMap.put(PD.Name,PD);
        }
        
        return userMap.values();
    }
    
    
    
    
    
    
    //fetchSalesOrder  for Search Button
    @AuraEnabled
    public static List<wrapperSalesOrder> fetchSalesOrder(String accountId, String ownerId,Date strtDate,String statusOrder,Date edDate,Boolean isSameDate){
        System.debug('statusOrder  @@@  '+statusOrder)  ;
        System.debug('isSameDate at controller '+isSameDate);
        String orderSubStatus ='';
        String orderSubStatus1 ='';
        
        Boolean isCommercialLeader = false;
        Boolean isCommercialMgr = false;
        Boolean isCountryMgr = false;
        Boolean isAdmin = false;
        
        List<Profile> lstProfile = new List<Profile>();
        Id id1 = UserInfo.getProfileId();
        lstProfile = [Select Name from Profile where Id =:id1 LIMIT 1];
        System.debug('profileName is '+lstProfile[0].Name);
        System.debug('Login Ad profileName is '+lstProfile[0].Name);
        
        
        if(lstProfile[0].Name == 'Commercial Leader NUCO Colombia'){
            isCommercialLeader = true;
            
        }
        if(lstProfile[0].Name == 'Commercial Manager NUCO Colombia'){
            isCommercialMgr = true;
            
        }
        if(lstProfile[0].Name == 'Country Manager NUCO Colombia'){
            isCountryMgr = true;
            
        }
        if(lstProfile[0].Name == 'Admin NUCO Colombia' || lstProfile[0].Name.contains('Admin')){
            isAdmin = true;
        }
        
        
        
        System.debug('#### isAdmin '+isAdmin);
        List<Sales_Order__c > salesOrderLst = new List<Sales_Order__c>();
        
        if(accountId!=null && statusOrder =='none' && strtDate == null && edDate == null && ownerId == null ){
            System.debug('Indside Account only'); 
            salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                            Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                            createdDate,OrderSubStatus__c,
                            SalesOrgCode__c,SAP_Order_Number__c
                            From Sales_Order__c 
                            Where SalesOrgCode__c='5710' 
                            AND Sold_to_Party__c =:accountId];
            
        }
        
        
        // @@@ if Account and Status is Selected by User
        if(accountId!=null && statusOrder!='none' && strtDate == null && edDate == null && ownerId == null){
            // if Orderstatus is select as Pending
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND Order_Status__c=:statusOrder
                                AND Sold_to_Party__c =:accountId];
                
            }else{
                if(statusOrder == 'Draft'){
                    orderSubStatus='Draft';
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    statusOrder ='Pending';
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Sold_to_Party__c =:accountId
                                    AND (Order_Status__c=:statusOrder
                                         OR Order_Status__c='Not yet processed'
                                         OR Order_Status__c='Partially processed' 
                                         OR Order_Status__c='Completely processed'
                                         OR Order_Status__c='In Transit' 
                                         OR Order_Status__c ='Error from SAP')]; 
                                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c='Pending' 
                                    AND(OrderSubStatus__c =:orderSubStatus OR OrderSubStatus__c =:orderSubStatus1)];
                    
                }
                
                
                
                
            }// end of else Part
            
        }
        
        // @@@ if all selected by user
        if(accountId!=null && statusOrder!='none' && strtDate !=null && edDate != null && ownerId != null){
            System.debug('strtDate '+strtDate);
            System.debug('edDate '+edDate);
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                System.debug('Condition one isSameDate '+isSameDate);
                if(isSameDate){
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND Sold_to_Party__c =:accountId 
                                    AND DAY_ONLY(createdDate) =: strtDate
                                    AND OwnerId=:ownerId];
                    System.debug('Condition one salesOrderLst '+salesOrderLst.size());
                    
                }else{
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND Sold_to_Party__c =:accountId 
                                    AND DAY_ONLY(createdDate) >=: strtDate 
                                    AND DAY_ONLY(createdDate) <=:  edDate
                                    AND OwnerId=:ownerId]; 
                }
                
                
                
            }else{
                if(statusOrder == 'Draft'){
                    orderSubStatus='Draft';
                    
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }else {
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                    
                    
                    
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c=:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OwnerId=:ownerId
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                    
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OwnerId=:ownerId
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OwnerId=:ownerId
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                    }
                    
                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OwnerId=:ownerId
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OwnerId=:ownerId
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                    }
                    
                    
                }
                
                
                
                
            }// end of else Part
        }
        
        // if user selected Account and start date & end date and Status is not selected 
        if(accountId!=null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null){
            if(isSameDate){
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND Sold_to_Party__c =:accountId 
                                AND DAY_ONLY(createdDate) =: strtDate];
                
                
            }else{
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND Sold_to_Party__c =:accountId 
                                AND DAY_ONLY(createdDate) >=: strtDate 
                                AND DAY_ONLY(createdDate) <=:  edDate];  
            }
            
        }
        
        //@@@ if user selected only Status
        if(accountId ==null && statusOrder !='none' && strtDate ==null && edDate == null && ownerId == null){
            if(isAdmin){
                System.debug('In Fetch Order '+isAdmin);
                if(statusOrder =='Approved'){
                    statusOrder = 'Open';
                }
                System.debug('statusOrder in Fetch Order '+statusOrder);
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND Order_Status__c=:statusOrder];
                
            }else{
                if(statusOrder == 'Draft'){
                    orderSubStatus='Draft';
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710'
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c='Pending'
                                    AND OrderSubStatus__c=:orderSubStatus];
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c=:orderSubStatus];
                    
                    
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    System.debug('Only selecting status statusOrder '+statusOrder);
                    System.debug('Only selecting status orderSubStatus '+orderSubStatus);
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND (Order_Status__c=:statusOrder 
                                         OR Order_Status__c='Not yet processed' 
                                         OR Order_Status__c='Partially processed' 
                                         OR Order_Status__c='Completely processed' 
                                         OR Order_Status__c='In Transit' 
                                         OR Order_Status__c ='Error from SAP' )];
                    
                    
                }else if(statusOrder =='PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                }
                
            }// end of else Part
        }
        
        //@@@ if user select Status and Start date and End Date
        if(accountId ==null && statusOrder !='none' && strtDate !=null && edDate != null && ownerId == null){
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                
                if(isSameDate){
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND DAY_ONLY(createdDate) =: strtDate]; 
                    
                    
                }else{
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND DAY_ONLY(createdDate) >=: strtDate 
                                    AND DAY_ONLY(createdDate) <=:  edDate]; 
                }
                
                
            }else{
                
                if(statusOrder == 'Draft'){
                    
                    orderSubStatus='Draft';
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OrderSubStatus__c =:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c =:orderSubStatus]; 
                    }
                    
                    
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OrderSubStatus__c =:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }
                    
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                    }
                    
                    
                }else if(statusOrder=='PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND (OrderSubStatus__c =:orderSubStatus OR OrderSubStatus__c =:orderSubStatus1)];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (OrderSubStatus__c =:orderSubStatus OR OrderSubStatus__c =:orderSubStatus1)];
                    }
                    
                }
                
                
                
                
            }// end of else Part
            
        }
        //if user select on starts and End Date
        if(accountId ==null && statusOrder =='none' && strtDate !=null && edDate != null && ownerId == null){
            System.debug('only selecting Start date and End Date isSameDate ' +isSameDate);
            System.debug('inside isSameDate');
            System.debug('inside isSamesDate strtDate '+strtDate);
            System.debug('inside isSamesDate EndDate '+Date.valueOf(edDate));
            if(isSameDate){
                
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND DAY_ONLY(createdDate) =: strtDate];
                
                
            }else{
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND DAY_ONLY(createdDate) >=: strtDate 
                                AND DAY_ONLY(createdDate) <=:  edDate]; 
            }
            
            System.debug('inside isSameDate salesOrderLst '+salesOrderLst.size());
            
            
        }
        
        
        
        //ownerId
        //if user selected only Owner Id
        if(accountId == null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null){
            salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                            Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                            createdDate,OrderSubStatus__c,
                            SalesOrgCode__c,SAP_Order_Number__c
                            From Sales_Order__c 
                            Where SalesOrgCode__c='5710' 
                            AND OwnerId =: ownerId];
        }
        
        //if user selected Owner ID And Account Name
        if(accountId != null && statusOrder =='none' && strtDate == null && edDate == null && ownerId!=null){
            salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                            Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                            createdDate,OrderSubStatus__c,
                            SalesOrgCode__c,SAP_Order_Number__c
                            From Sales_Order__c 
                            Where SalesOrgCode__c='5710' 
                            AND OwnerId =: ownerId
                            AND Sold_to_Party__c =:accountId];
        }
        
        //@@@ if user selected account, Status and Owner Name
        if(accountId != null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null){
            
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND OwnerId =: ownerId
                                AND Sold_to_Party__c =:accountId
                                AND Order_Status__c=:statusOrder];
                
            }else{
                
                if(statusOrder == 'Draft'){
                    
                    orderSubStatus='Draft';
                    
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c=:orderSubStatus];
                    
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c='Pending'
                                    AND OrderSubStatus__c=:orderSubStatus]; 
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c=:orderSubStatus];
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND (Order_Status__c=:statusOrder 
                                         OR Order_Status__c='Not yet processed' 
                                         OR Order_Status__c='Partially processed' 
                                         OR Order_Status__c='Completely processed' 
                                         OR Order_Status__c='In Transit' 
                                         OR Order_Status__c ='Error from SAP')];
                                    
                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                }
                
                
                
                
            }// end of else Part
        }
        
        //@@@ if user selected owner id, account Name and Status and Start date and End Date
        if(accountId != null && statusOrder !='none' && strtDate != null && edDate != null && ownerId!=null){
            
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                
                if(isSameDate){
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND DAY_ONLY(createdDate) =: strtDate]; 
                    
                }else{
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Sold_to_Party__c =:accountId
                                    AND Order_Status__c=:statusOrder
                                    AND DAY_ONLY(createdDate) >=: strtDate 
                                    AND DAY_ONLY(createdDate) <=:  edDate];
                }
                
                
            }else{
                if(statusOrder == 'Draft'){
                    
                    orderSubStatus='Draft';
                    
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OrderSubStatus__c=:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c='Pending'
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OrderSubStatus__c=:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c='Pending'
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND OrderSubStatus__c=:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c=:orderSubStatus];  
                    }
                    
                    
                }else if(statusOrder == 'Approved' || Test.isRunningTest()){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                    }
                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND OwnerId =: ownerId
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)]; 
                    }
                    
                    
                }
                
            }// end of else Part
            
        }
        
        // user selected owner id and Start Date and End date
        if(accountId == null && statusOrder =='none' && strtDate != null && edDate != null && ownerId!=null){
            if(isSameDate){
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND OwnerId =: ownerId
                                AND DAY_ONLY(createdDate) =: strtDate]; 
                
                
            }else{
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND OwnerId =: ownerId
                                AND DAY_ONLY(createdDate) >=: strtDate 
                                AND DAY_ONLY(createdDate) <=:  edDate];
            }
            
            
            
        }
        //@@@ if user selected Owner id and Status only
        if(accountId == null && statusOrder !='none' && strtDate == null && edDate == null && ownerId!=null){
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                createdDate,OrderSubStatus__c,
                                SalesOrgCode__c,SAP_Order_Number__c
                                From Sales_Order__c 
                                Where SalesOrgCode__c='5710' 
                                AND OwnerId =: ownerId
                                AND Order_Status__c=:statusOrder];
                
            }else{
                if(statusOrder == 'Draft'){
                    
                    orderSubStatus='Draft';
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Order_Status__c='Pending'
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Order_Status__c=:statusOrder
                                    AND OrderSubStatus__c =:orderSubStatus];
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND (Order_Status__c=:statusOrder 
                                         OR Order_Status__c='Not yet processed' 
                                         OR Order_Status__c='Partially processed' 
                                         OR Order_Status__c='Completely processed' 
                                         OR Order_Status__c='In Transit' 
                                         OR Order_Status__c ='Error from SAP')];
                    
                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    } 
                    
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND OwnerId =: ownerId
                                    AND Order_Status__c=:statusOrder
                                    AND (OrderSubStatus__c =:orderSubStatus OR OrderSubStatus__c =:orderSubStatus1)];
                    
                }
                
                
                
            }// end of else Part
        }
        
        // @@@ if ownerId is null is Selected by User
        if(accountId!=null && statusOrder!='none' && strtDate != null && edDate != null && ownerId == null){
            // if Orderstatus is select as Pending
            if(isAdmin){
                if(statusOrder == 'Approved'){
                    statusOrder = 'Open';
                }
                if(isSameDate){
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND Sold_to_Party__c =:accountId 
                                    AND DAY_ONLY(createdDate) =: strtDate];
                    System.debug('Condition one salesOrderLst '+salesOrderLst.size());
                    
                }else{
                    salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                    Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                    createdDate,OrderSubStatus__c,
                                    SalesOrgCode__c,SAP_Order_Number__c
                                    From Sales_Order__c 
                                    Where SalesOrgCode__c='5710' 
                                    AND Order_Status__c=:statusOrder
                                    AND Sold_to_Party__c =:accountId 
                                    AND DAY_ONLY(createdDate) >=: strtDate 
                                    AND DAY_ONLY(createdDate) <=:  edDate]; 
                }
                
            }else{
                
                System.debug('At owner id statusOrder '+statusOrder);
                
                if(statusOrder == 'Draft'){
                    
                    orderSubStatus='Draft';
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }else {
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710'
                                        AND Sold_to_Party__c =:accountId
                                        AND Order_Status__c=:statusOrder
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c =:orderSubStatus];
                    }
                    
                    System.debug('salesOrderLst : '+salesOrderLst);
                }
                else if(statusOrder == 'My_Pending_Orders'){
                    if(isCommercialLeader){
                        orderSubStatus='Pending for manager approval';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Pending at Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Pending for director approval';
                    }
                    statusOrder ='Pending';
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c='Pending'
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                    
                }else if(statusOrder == 'Rejected'){
                    if(isCommercialLeader){
                        orderSubStatus='Rejected by manager';
                    }
                    if(isCommercialMgr){
                        orderSubStatus='Rejected by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        orderSubStatus='Rejected by director';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND OrderSubStatus__c=:orderSubStatus];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND OrderSubStatus__c=:orderSubStatus]; 
                    }
                    
                }else if(statusOrder == 'Approved'){
                    if(isCommercialLeader){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by manager';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by Sales Office Manager';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Open';
                        orderSubStatus='Approved by director';
                    }
                    
                    
                    System.debug('###### Is Same date '+isSameDate);
                    System.debug('###### accountId '+accountId);
                    System.debug('###### strtDate '+strtDate);
                    System.debug('###### orderSubStatus '+orderSubStatus);
                    System.debug('###### statusOrder '+statusOrder);
                    
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate 
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (Order_Status__c=:statusOrder 
                                             OR Order_Status__c='Not yet processed' 
                                             OR Order_Status__c='Partially processed' 
                                             OR Order_Status__c='Completely processed' 
                                             OR Order_Status__c='In Transit' 
                                             OR Order_Status__c ='Error from SAP')];
                    }
                    System.debug('salesOrderLst Size @@ '+salesOrderLst.size());
                    
                    
                }else if(statusOrder == 'PendingForOthers'){
                    
                    if(isCommercialLeader){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending at Sales Office Manager';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCommercialMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending for director approval';
                    }
                    if(isCountryMgr){
                        statusOrder = 'Pending';
                        orderSubStatus='Pending for manager approval';
                        orderSubStatus1 ='Pending at Sales Office Manager';
                    }
                    
                    if(isSameDate){
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) =: strtDate
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                        
                    }else{
                        salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,
                                        Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                                        createdDate,OrderSubStatus__c,
                                        SalesOrgCode__c,SAP_Order_Number__c
                                        From Sales_Order__c 
                                        Where SalesOrgCode__c='5710' 
                                        AND Order_Status__c=:statusOrder
                                        AND Sold_to_Party__c =:accountId 
                                        AND DAY_ONLY(createdDate) >=: strtDate 
                                        AND DAY_ONLY(createdDate) <=:  edDate
                                        AND (OrderSubStatus__c=:orderSubStatus OR OrderSubStatus__c=:orderSubStatus1)];
                    }
                }
                
            }// end of else Part
            
        }
        
        List<wrapperSalesOrder> wrapList = new List<wrapperSalesOrder>();
        
        for(Sales_Order__c salesObj :salesOrderLst){
            wrapperSalesOrder wrapperSalesOrderObj = new wrapperSalesOrder();
            wrapperSalesOrderObj.Id = salesObj.Id;
            // wrapperSalesOrderObj.url = '/'+salesObj.Id;
            //window.self.location.href='/apex/
            //  wrapperSalesOrderObj.url =win
            wrapperSalesOrderObj.url = '/'+salesObj.Id;
            wrapperSalesOrderObj.Sales_Order_Number = salesObj.Name ;
            wrapperSalesOrderObj.AccountName = salesObj.Sold_to_Party__r.Name;
            System.debug('####@ Status is '+salesObj.Order_Status__c);
            
            System.debug('#### Status is '+salesObj.Order_Status__c);
            if(salesObj.Order_Status__c =='Pending'){
                wrapperSalesOrderObj.Status = System.Label.Pending;
            }else if(salesObj.Order_Status__c =='Open' || salesObj.Order_Status__c =='Not yet processed' || salesObj.Order_Status__c =='Partially processed' || salesObj.Order_Status__c =='Completely processed' || salesObj.Order_Status__c =='Error from SAP' || salesObj.Order_Status__c =='In Transit' ){
                wrapperSalesOrderObj.Status = System.Label.Approved;
            }else if(salesObj.Order_Status__c =='Rejected'){
                wrapperSalesOrderObj.Status = System.Label.Rejected;
            }
            else if(salesObj.Order_Status__c =='Draft'){
                wrapperSalesOrderObj.Status = System.Label.Draft;
            }
            
            //wrapperSalesOrderObj.Status = salesObj.Order_Status__c;
            wrapperSalesOrderObj.totalValue = salesObj.Net_Amount__c ;
            wrapperSalesOrderObj.dateFAT = salesObj.DateofFAT__c;
            
            DateTime dt = salesObj.createdDate; 
            String dtStr = dt.format('MM/dd/yyyy');
            wrapperSalesOrderObj.creationDate = dtStr;
            wrapperSalesOrderObj.subStatusOrder = salesObj.OrderSubStatus__c;
            wrapperSalesOrderObj.SalesOrg = salesObj.Sales_Org_lk__r.Name;
            wrapList.add(wrapperSalesOrderObj);
            
        }
        
        return wrapList;
    }
    
    
    
    @AuraEnabled
    public static List<wrapperSalesOrder> fetchSalesOrder1(String accountId,String strtDate,String statusOrder,String edDate,String subOrderStatus){
        String orderSubStatus ='';
        List<Profile> lstProfile = new List<Profile>();
        Id id1 = UserInfo.getProfileId();
        lstProfile = [Select Name from Profile where Id =:id1 LIMIT 1];
        System.debug('profileName is '+lstProfile[0].Name);
        
        List<Sales_Order__c > salesOrderLst = new List<Sales_Order__c>();
        String profileName =  lstProfile[0].Name;
        if(profileName.contains('Admin')){
            System.debug('@@@ statusOrder '+statusOrder);
            salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,Order_Date__c,
                            Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                            createdDate,OrderSubStatus__c,
                            SalesOrgCode__c,SAP_Order_Number__c
                            From Sales_Order__c  
                            Where SalesOrgCode__c='5710' 
                            AND Order_Status__c=:statusOrder];
            
        }else{
            if(lstProfile[0].Name == 'Commercial Leader NUCO Colombia'){
                orderSubStatus='Pending for manager approval';
            }
            if(lstProfile[0].Name == 'Commercial Manager NUCO Colombia'){
                orderSubStatus='Pending at Sales Office Manager';
            }
            if(lstProfile[0].Name == 'Country Manager NUCO Colombia'){
                orderSubStatus='Pending for director approval';
            }
            
            salesOrderLst =[select id , Name,Sold_to_Party__r.Name ,Order_Status__c,Order_Date__c,
                            Net_Amount__c,DateofFAT__c,Sales_Org_lk__r.Name,
                            createdDate,OrderSubStatus__c,
                            SalesOrgCode__c,SAP_Order_Number__c
                            From Sales_Order__c Where SalesOrgCode__c='5710' 
                            AND Order_Status__c=:statusOrder
                            AND OrderSubStatus__c=:orderSubStatus];  
        }
        
        
        
        
        List<wrapperSalesOrder> wrapList = new List<wrapperSalesOrder>();
        
        for(Sales_Order__c salesObj :salesOrderLst){
            wrapperSalesOrder wrapperSalesOrderObj = new wrapperSalesOrder();
            wrapperSalesOrderObj.Id = salesObj.Id;
            //wrapperSalesOrderObj.url = '/'+salesObj.Id;
            wrapperSalesOrderObj.url = '/'+salesObj.Id;
            wrapperSalesOrderObj.Sales_Order_Number = salesObj.Name ;
            wrapperSalesOrderObj.AccountName = salesObj.Sold_to_Party__r.Name;
            
            
            System.debug('#### Status is '+salesObj.Order_Status__c);
            if(salesObj.Order_Status__c =='Pending'){
                wrapperSalesOrderObj.Status = System.Label.Pending;
            }else if(salesObj.Order_Status__c =='Open'){
                wrapperSalesOrderObj.Status = System.Label.Approved;
            }else if(salesObj.Order_Status__c =='Rejected'){
                wrapperSalesOrderObj.Status = System.Label.Rejected;
            }
            
            
            
            //wrapperSalesOrderObj.Status = salesObj.Order_Status__c;
            wrapperSalesOrderObj.totalValue = salesObj.Net_Amount__c ;
            wrapperSalesOrderObj.dateFAT = salesObj.DateofFAT__c;
            
            
            DateTime dt = salesObj.createdDate; 
            String dtStr = dt.format('MM/dd/yyyy');
            wrapperSalesOrderObj.creationDate = dtStr;
            
            
            wrapperSalesOrderObj.subStatusOrder = salesObj.OrderSubStatus__c;
            wrapperSalesOrderObj.SalesOrg = salesObj.Sales_Org_lk__r.Name;
            wrapList.add(wrapperSalesOrderObj);
            
        }
        
        return wrapList;
    }
    
    @AuraEnabled 
    public static List<profile> fetchProfile(){
        List<Profile> lstProfile = new List<Profile>();
        Id id1 = UserInfo.getProfileId();
        lstProfile = [Select Name from Profile where Id =:id1 LIMIT 1];
        System.debug('@@@@@@ profileName is '+lstProfile[0].Name);
        String profileName =  lstProfile[0].Name;
        if(profileName.contains('Admin')){
            return lstProfile;
        }else{
            return null;    
        }
        
    }
    
    
    
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperSalesOrder{
        @AuraEnabled public String Id{get;set;}
        @AuraEnabled public String url{get;set;}
        @AuraEnabled public String url1{get;set;}
        @AuraEnabled public String Sales_Order_Number{get;set;}
        @AuraEnabled public String AccountName {get;set;}
        @AuraEnabled public String Status{get;set;}
        @AuraEnabled public double totalValue {get;set;}
        @AuraEnabled public date dateFAT{get;set;}
        @AuraEnabled public String creationDate {get;set;}
        @AuraEnabled public String subStatusOrder{get;set;}
        @AuraEnabled public String SalesOrg {get;set;}
        
        public wrapperSalesOrder (){
            Sales_Order_Number ='';
            AccountName='';
            Status='';
            //totalValue ='';
            // dateFAT ='';
            // creattionDate='';
            subStatusOrder='';
            SalesOrg ='';
            url='';
            url1='';
        }
    }
    
}