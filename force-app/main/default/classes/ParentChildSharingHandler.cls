Public class ParentChildSharingHandler{

    private boolean m_isExecuting = false;

    public ParentChildSharingHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }

    public void OnAfterInsert(List<Parent_Child_Mapping__c> newRecords, String fromDate, String toDate){
    	set<Id> childAccountIds = new set<Id>();
        set<Id> parenAccountIds = new set<Id>(); 
        Map<ID,ID> childParentMap = new Map<ID,ID>();        
                        
        for(Parent_Child_Mapping__c pcm : newRecords){            
           	if(pcm.Parent_Account__c != null && pcm.Child_Account__c!=null && pcm.Active__c == True){
                childAccountIds.add(pcm.Child_Account__c);  // Child Account Id                
                parenAccountIds.add(pcm.Parent_Account__c); // Parent Account Id            
                if(!childParentMap.ContainsKey(pcm.Child_Account__c)){
                     childParentMap.put(pcm.Child_Account__c,pcm.Parent_Account__c);
                }
           	}                            
        }
        
        if(childParentMap.size()>0){
            List<User> parentAccountUsers = [select Id, AccountId, Name, UserRoleId from user where AccountId IN :parenAccountIds];        
            Map<ID,ID> parentAccountIDUserRoleIdMap = New Map<ID,ID> ();            
            set<Id> parentRoleId = new set<Id>();
            for(User u : parentAccountUsers){
                parentRoleId.add(u.UserRoleId);                
                if(!parentAccountIDUserRoleIdMap.ContainsKey(u.AccountId)){
                   	parentAccountIDUserRoleIdMap.put(u.AccountId,u.UserRoleId);
                }
            }            
            Map<ID,ID> parentUserRoleIdGroupIdMap = New Map<ID,ID> ();                                                
            List<Group> parentGrpIds = [Select Id, Name, RelatedId, Type From Group where RelatedId IN (select Id from userRole where Id IN :parentRoleId) and type='RoleAndSubordinates'];      
            for(Group pg : parentGrpIds){                
                if(!parentUserRoleIdGroupIdMap.ContainsKey(pg.RelatedId)){
                   	parentUserRoleIdGroupIdMap.put(pg.RelatedId,pg.Id);
                }
            }
                                                
            List<Sales_Order__c> orderList = new List<Sales_Order__c>();
            String salesOrderQuery ='select Id, Name, Sold_To_Party__c from Sales_Order__c where Sold_To_Party__c IN :childAccountIds and Order_Date__c>='+fromDate+' and Order_Date__c<='+toDate+'';   
            orderList = Database.query(salesOrderQuery);
            List<Sales_Order__Share> listSOShare = new List<Sales_Order__Share>();
            if(orderList.size()>0){
                for(Sales_Order__c s : orderList){            	
            	If(childParentMap.containsKey(s.Sold_To_Party__c)){
                         If(parentAccountIDUserRoleIdMap.containsKey(childParentMap.get(s.Sold_To_Party__c))){
                                If(parentUserRoleIdGroupIdMap.containsKey(parentAccountIDUserRoleIdMap.get(childParentMap.get(s.Sold_To_Party__c)))){                            
                                    String groupId = parentUserRoleIdGroupIdMap.get(parentAccountIDUserRoleIdMap.get(childParentMap.get(s.Sold_To_Party__c)));                                
                                    Sales_Order__Share orderShare = new Sales_Order__Share();
                                    orderShare.ParentId = s.Id;
                                    orderShare.UserOrGroupId = groupId;
                                    orderShare.AccessLevel = 'Read';                                
                                    listSOShare.add(orderShare);
                                }
                         }
                   }                                 
            }
            List<Database.SaveResult> soShareRslt = Database.insert(listSOShare,false);
            }
            
            List<Invoice__c> invoiceList = new List<Invoice__c>();
            String invoiceQuery = 'select Id, Name, Sold_To_Party__c from Invoice__c where Sold_To_Party__c IN :childAccountIds and Billing_Date__c>='+fromDate+' and Billing_Date__c<='+toDate+'';
            invoiceList = Database.query(invoiceQuery);
            List<Invoice__Share> listInvoiceShare = new List<Invoice__Share>();
            if(invoiceList.size()>0){
                for(Invoice__c i : invoiceList){            	
            	If(childParentMap.containsKey(i.Sold_To_Party__c)){
                         If(parentAccountIDUserRoleIdMap.containsKey(childParentMap.get(i.Sold_To_Party__c))){
                                If(parentUserRoleIdGroupIdMap.containsKey(parentAccountIDUserRoleIdMap.get(childParentMap.get(i.Sold_To_Party__c)))){                            
                                    String groupId = parentUserRoleIdGroupIdMap.get(parentAccountIDUserRoleIdMap.get(childParentMap.get(i.Sold_To_Party__c)));                                                                                                        
                                    Invoice__Share invoiceShare = new Invoice__Share();
                                    invoiceShare.ParentId = i.Id;
                                    invoiceShare.UserOrGroupId = groupId;
                                    invoiceShare.AccessLevel = 'Read';
                                    listInvoiceShare.add(invoiceShare);
                                }
                         }
                   }                                 
            }
            List<Database.SaveResult> invoiceShareRslt = Database.insert(listInvoiceShare,false);
            }
                                                            
        }                                       
    }
  
    public void OnAfterUpdate(List<Parent_Child_Mapping__c> oldRecords, List<Parent_Child_Mapping__c> newRecords, Map<ID,Parent_Child_Mapping__c> ObjectMap, String fromDate, String toDate){        
    	set<Id> childAccountIds = new set<Id>();
        set<Id> parenAccountIds = new set<Id>(); 
        Map<ID,ID> childParentMap = new Map<ID,ID>(); 
        for(Parent_Child_Mapping__c pcm : newRecords){
            if(!childParentMap.ContainsKey(pcm.Child_Account__c)){
            	childParentMap.put(pcm.Child_Account__c,pcm.Parent_Account__c);
            }
        }
                                       
        for(Parent_Child_Mapping__c pcm : newRecords){            
           	if(pcm.Parent_Account__c != null && pcm.Child_Account__c!=null && pcm.Active__c == True){
                childAccountIds.add(pcm.Child_Account__c);  // Child Account Id                
                parenAccountIds.add(pcm.Parent_Account__c); // Parent Account Id                            
           	}                            
        }
        
        if(childAccountIds.size()>0 && parenAccountIds.size()>0){
            List<User> parentAccountUsers = [select Id, AccountId, Name, UserRoleId from user where AccountId IN :parenAccountIds];        
            Map<ID,ID> parentAccountIDUserRoleIdMap = New Map<ID,ID> ();            
            set<Id> parentRoleId = new set<Id>();
            for(User u : parentAccountUsers){
                parentRoleId.add(u.UserRoleId);                
                if(!parentAccountIDUserRoleIdMap.ContainsKey(u.AccountId)){
                	parentAccountIDUserRoleIdMap.put(u.AccountId,u.UserRoleId);
                }
            }            
            Map<ID,ID> parentUserRoleIdGroupIdMap = New Map<ID,ID> ();                                                
            List<Group> parentGrpIds = [Select Id, Name, RelatedId, Type From Group where RelatedId IN (select Id from userRole where Id IN :parentRoleId) and type='RoleAndSubordinates'];      
            for(Group pg : parentGrpIds){                
                if(!parentUserRoleIdGroupIdMap.ContainsKey(pg.RelatedId)){
                   	parentUserRoleIdGroupIdMap.put(pg.RelatedId,pg.Id);
                }
            }    
            List<Sales_Order__c> orderList = new List<Sales_Order__c>();
            String salesOrderQuery ='select Id, Name, Sold_To_Party__c from Sales_Order__c where Sold_To_Party__c IN :childAccountIds and Order_Date__c>='+fromDate+' and Order_Date__c<='+toDate+'';   
            orderList = Database.query(salesOrderQuery);
            List<Sales_Order__Share> listSOShare = new List<Sales_Order__Share>();
            if(orderList.size()>0){
                for(Sales_Order__c s : orderList){            
                    If(childParentMap.containsKey(s.Sold_To_Party__c)){
                         If(parentAccountIDUserRoleIdMap.containsKey(childParentMap.get(s.Sold_To_Party__c))){
                                If(parentUserRoleIdGroupIdMap.containsKey(parentAccountIDUserRoleIdMap.get(childParentMap.get(s.Sold_To_Party__c)))){                            
                                    String groupId = parentUserRoleIdGroupIdMap.get(parentAccountIDUserRoleIdMap.get(childParentMap.get(s.Sold_To_Party__c)));                                
                                    Sales_Order__Share orderShare = new Sales_Order__Share();
                                    orderShare.ParentId = s.Id;
                                    orderShare.UserOrGroupId = groupId;
                                    orderShare.AccessLevel = 'Read';                                
                                    listSOShare.add(orderShare);
                                }
                         }
                    }        
                }
                Database.insert(listSOShare,false);
            }
            
               
            List<Invoice__c> invoiceList = new List<Invoice__c>();
            String invoiceQuery = 'select Id, Name, Sold_To_Party__c from Invoice__c where Sold_To_Party__c IN :childAccountIds and Billing_Date__c>='+fromDate+' and Billing_Date__c<='+toDate+'';
            invoiceList = Database.query(invoiceQuery);            
            List<Invoice__Share> listInvoiceShare = new List<Invoice__Share>();
            if(invoiceList.size()>0){
                for(Invoice__c i : invoiceList){            	
                    If(childParentMap.containsKey(i.Sold_To_Party__c)){
                             If(parentAccountIDUserRoleIdMap.containsKey(childParentMap.get(i.Sold_To_Party__c))){
                                    If(parentUserRoleIdGroupIdMap.containsKey(parentAccountIDUserRoleIdMap.get(childParentMap.get(i.Sold_To_Party__c)))){                            
                                        String groupId = parentUserRoleIdGroupIdMap.get(parentAccountIDUserRoleIdMap.get(childParentMap.get(i.Sold_To_Party__c)));                                                                                                        
                                        Invoice__Share invoiceShare = new Invoice__Share();
                                        invoiceShare.ParentId = i.Id;
                                        invoiceShare.UserOrGroupId = groupId;
                                        invoiceShare.AccessLevel = 'Read';
                                        listInvoiceShare.add(invoiceShare);
                                    }
                             }
                       }                                 
                }
                List<Database.SaveResult> invoiceShareRslt = Database.insert(listInvoiceShare,false);
            }
                        
        }
        
        set<Id> childAccIds = new set<Id>();
        set<Id> parenAccIds = new set<Id>();         
        for(Parent_Child_Mapping__c pcm : newRecords){
            if(pcm.Parent_Account__c != null && pcm.Child_Account__c != null && pcm.Active__c == false){
            	childAccIds.add(pcm.Child_Account__c);
                parenAccIds.add(pcm.Parent_Account__c);
            }
        }
        
        if(childAccIds.size()>0 && parenAccIds.size()>0){
            
            List<User> parentAccountUsers = [select Id, AccountId, Name, UserRoleId from user where AccountId IN :parenAccIds];                           
            set<Id> parentRoleIds = new set<Id>();
            for(User u : parentAccountUsers){
                parentRoleIds.add(u.UserRoleId);
            }
            
            List<Group> parentGrpList = [Select Id, Name, RelatedId, Type From Group where RelatedId IN (select Id from userRole where Id IN :parentRoleIds) and type='RoleAndSubordinates'];
            set<Id> parentGrpIds = new set<Id>();
            for(Group g : parentGrpList){
                parentGrpIds.add(g.Id);
            }
            
            List<Sales_Order__c> childOrderList = [select Id, Name, Sold_To_Party__c from Sales_Order__c where Sold_To_Party__c IN :childAccIds];            
            set<Id> salesOrderIds = new set<Id>();
            if(childOrderList.size()>0){
                for(Sales_Order__c s : childOrderList){
                    salesOrderIds.add(s.Id);
                }
            }            
            List<Sales_Order__Share> shareToDelete = new List<Sales_Order__Share>();
            List<Sales_Order__Share> sharedSOList = new List<Sales_Order__Share>();
            if(Test.isRunningTest()){
                sharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual' limit 1];
            }else{
                sharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual'];
            }            
            if(sharedSOList.size()>0){
                for(Sales_Order__Share s :sharedSOList){
                    if(salesOrderIds.contains(s.ParentId)){
                        shareToDelete.add(s);
                    }
                }
                Database.Delete(shareToDelete, false);
            }
                        
            List<Invoice__c> childInvoiceList = [select Id, Name, Sold_To_Party__c from Invoice__c where Sold_To_Party__c IN :childAccIds];
            set<Id> invoiceIds = new set<Id>();
            if(childInvoiceList.size()>0){
                for(Invoice__c i : childInvoiceList){
                    invoiceIds.add(i.Id);
                }
            }
            
            List<Invoice__Share> invoiceShareToDelete = new List<Invoice__Share>();
            List<Invoice__Share> sharedInvoiceList = new List<Invoice__Share>();
            if(Test.isRunningTest()){
                sharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual' limit 1];
            }else{
                sharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual'];
            }
            
            
            if(sharedInvoiceList.size()>0){
                for(Invoice__Share i :sharedInvoiceList){
                    if(invoiceIds.contains(i.ParentId)){
                        invoiceShareToDelete.add(i);
                    }
                }
                Database.Delete(invoiceShareToDelete, false);
            }
            
        }
            
            set<Id> oldParentAccIds = new set<Id>();
            set<Id> oldChildAccIds = new set<Id>();
            Map<Id,Id> oldChildParentMap = new Map<Id,Id>();
            for(Parent_Child_Mapping__c pcm : oldRecords){
             	if(!oldChildParentMap.ContainsKey(pcm.Child_Account__c)){
           			oldChildParentMap.put(pcm.Child_Account__c,pcm.Parent_Account__c);
           		}   
            }
            for(Id i : oldChildParentMap.keySet()){
                if(oldChildParentMap.get(i)!=childParentMap.get(i)){
					oldParentAccIds.add(oldChildParentMap.get(i));
                    oldChildAccIds.add(i);
                }
            }
			
            if(oldParentAccIds.size()>0 && oldChildAccIds.size()>0){
                
                List<User> oldParentAccountUsers = [select Id, AccountId, Name, UserRoleId from user where AccountId IN :oldParentAccIds];                           
                set<Id> oldParentRoleIds = new set<Id>();
                for(User u : oldParentAccountUsers){
                    oldParentRoleIds.add(u.UserRoleId);
                }
                
                List<Group> oldParentGrpList = [Select Id, Name, RelatedId, Type From Group where RelatedId IN (select Id from userRole where Id IN :oldParentRoleIds) and type='RoleAndSubordinates'];
                set<Id> oldParentGrpIds = new set<Id>();
                for(Group g : oldParentGrpList){
                    oldParentGrpIds.add(g.Id);
                }
                
                List<Sales_Order__c> oldChildOrderList = [select Id, Name, Sold_To_Party__c from Sales_Order__c where Sold_To_Party__c IN :oldChildAccIds];
                set<Id> oldSalesOrderIds = new set<Id>();
                if(oldChildOrderList.size()>0){
                    for(Sales_Order__c s : oldChildOrderList){
                        oldSalesOrderIds.add(s.Id);
                    }
                }
                
                
                List<Sales_Order__Share> oldShareToDelete = new List<Sales_Order__Share>();
                List<Sales_Order__Share> oldSharedSOList = new List<Sales_Order__Share>();
                if(Test.isRunningTest()){
                    oldSharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :oldParentGrpIds and RowCause='Manual' limit 1];
                }else{
                    oldSharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :oldParentGrpIds and RowCause='Manual'];
                }
                
                if(oldSharedSOList.size()>0){
                    for(Sales_Order__Share s :oldSharedSOList){
                        if(oldSalesOrderIds.contains(s.ParentId)){
                            oldShareToDelete.add(s);
                        }
                    }
                    Database.Delete(oldShareToDelete, false);
                }
                                                
                List<Invoice__c> oldChildInvoiceList = [select Id, Name, Sold_To_Party__c from Invoice__c where Sold_To_Party__c IN :oldChildAccIds];
                set<Id> oldInvoiceIds = new set<Id>();
                if(oldChildInvoiceList.size()>0){
                    for(Invoice__c i : oldChildInvoiceList){
                        oldInvoiceIds.add(i.Id);
                    }
                }
                                
                List<Invoice__Share> oldInvoiceShareToDelete = new List<Invoice__Share>();
                List<Invoice__Share> oldSharedInvoiceList = new List<Invoice__Share>();
                if(Test.isRunningTest()){
                    oldSharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :oldParentGrpIds and RowCause='Manual' limit 1];
                }else{
                    oldSharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :oldParentGrpIds and RowCause='Manual'];
                }
                
                if(oldSharedInvoiceList.size()>0){
                    for(Invoice__Share i :oldSharedInvoiceList){
                        if(oldInvoiceIds.contains(i.ParentId)){
                            oldInvoiceShareToDelete.add(i);
                        }
                    }
                    Database.Delete(oldInvoiceShareToDelete, false);
                }                
            }

                                                                               
    }

    public void OnBeforeDelete(List<Parent_Child_Mapping__c> oldRecords, Map<ID,Parent_Child_Mapping__c> ObjectMap, String fromDate, String toDate){
    	set<Id> childAccIds = new set<Id>();
        set<Id> parenAccIds = new set<Id>();
        
        for(Parent_Child_Mapping__c pcm : oldRecords){
            if(pcm.Parent_Account__c != null && pcm.Child_Account__c != null && pcm.Active__c == true){
            	childAccIds.add(pcm.Child_Account__c);
                parenAccIds.add(pcm.Parent_Account__c);
            }
        }
        if(childAccIds.size()>0 && parenAccIds.size()>0){
            
            List<User> parentAccountUsers = [select Id, AccountId, Name, UserRoleId from user where AccountId IN :parenAccIds];                           
            set<Id> parentRoleIds = new set<Id>();
            for(User u : parentAccountUsers){
                parentRoleIds.add(u.UserRoleId);
            }
            
            List<Group> parentGrpList = [Select Id, Name, RelatedId, Type From Group where RelatedId IN (select Id from userRole where Id IN :parentRoleIds) and type='RoleAndSubordinates'];
            set<Id> parentGrpIds = new set<Id>();
            for(Group g : parentGrpList){
                parentGrpIds.add(g.Id);
            }
            
            List<Sales_Order__c> childOrderList = [select Id, Name, Sold_To_Party__c from Sales_Order__c where Sold_To_Party__c IN :childAccIds];
            set<Id> salesOrderIds = new set<Id>();
            if(childOrderList.size()>0){
                for(Sales_Order__c s : childOrderList){
                    salesOrderIds.add(s.Id);
                }
            }
            
            List<Sales_Order__Share> shareToDelete = new List<Sales_Order__Share>();
            List<Sales_Order__Share> sharedSOList = new List<Sales_Order__Share>();
            if(Test.isRunningTest()){
                sharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual'];
            }else{
                sharedSOList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Sales_Order__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual'];
            }
            
            if(sharedSOList.size()>0){
                for(Sales_Order__Share s :sharedSOList){
                    if(salesOrderIds.contains(s.ParentId)){
                        shareToDelete.add(s);
                    }
                }
                Database.Delete(shareToDelete, false);
            }
                       
            List<Invoice__c> childInvoiceList = [select Id, Name, Sold_To_Party__c from Invoice__c where Sold_To_Party__c IN :childAccIds];
            set<Id> invoiceIds = new set<Id>();
            if(childInvoiceList.size()>0){
                for(Invoice__c i : childInvoiceList){
                    invoiceIds.add(i.Id);
                }
            }
            
            List<Invoice__Share> invoiceShareToDelete = new List<Invoice__Share>();
            List<Invoice__Share> sharedInvoiceList = new List<Invoice__Share>();
            if(Test.isRunningTest()){
                sharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual' limit 1];
            }else{
                sharedInvoiceList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Invoice__Share where UserOrGroupId IN :parentGrpIds and RowCause='Manual'];
            }
            
            if(sharedInvoiceList.size()>0){
                for(Invoice__Share i :sharedInvoiceList){
                    if(invoiceIds.contains(i.ParentId)){
                        invoiceShareToDelete.add(i);
                    }
                }
                Database.Delete(invoiceShareToDelete, false);
            }
            
        }	            
    }
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }

}