global class AccountShareBatchClass implements Database.Batchable<sObject> {
    
  global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        Datetime halfHourBack = Datetime.now().addMinutes(-30);
      //  String query = 'Select id,Sales_Org_Code__c,OwnerId,(Select id,AccountOwner__c,AccountOwner__r.Name from Distributor_Sales_Areas__r where LastModifiedDate = :halfHourBack  ) from Account';
      String query='Select id,AccountOwner__c,AccountOwner__r.Name,LastModifiedDate,Distributor__c,Distributor__r.OwnerID from DistributorSalesAreaMapping__c where isAccountOwnerChanged__c=true' ;
      return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<DistributorSalesAreaMapping__c> salesArea){
       List<WrapClass> wrapperClassList=new List<WrapClass>();
              Set<id> AccountSet=new Set<id>();
            if(salesArea.size()>0)
            {
            for(DistributorSalesAreaMapping__c salesAreaMapping:salesArea)
            { salesAreaMapping.isAccountOwnerChanged__c=false;
                if(salesAreaMapping.AccountOwner__c!=salesAreaMapping.Distributor__r.OwnerID)
            {System.debug('salesAreaMapping'+salesAreaMapping);
                AccountSet.add(salesAreaMapping.Distributor__c);
                WrapClass wc=new WrapClass();
wc.AccountId=salesAreaMapping.Distributor__c;
wc.New_UserId=salesAreaMapping.AccountOwner__c;
wrapperClassList.add(wc);
               
            }
            }
         update salesArea;
            
            }
  List<AccountShare> AccountShareList = new List<AccountShare>([Select id, AccountID, UserOrGroupId,RowCause  from AccountShare where AccountID in: AccountSet ]);        
   List<AccountShare> newAccountShares=new List<AccountShare>();
          for(WrapClass w : wrapperClassList) 
{
AccountShare thisAccountShare = new AccountShare(); 

thisAccountShare.userorgroupid = w.New_UserId;
thisAccountShare.accountid = w.AccountID;
thisAccountShare.accountaccesslevel = 'Edit';
thisAccountShare.OpportunityAccessLevel = 'None';
thisAccountShare.CaseAccessLevel = 'None';
thisAccountShare.ContactAccessLevel = 'Edit';

newAccountShares.add(thisAccountShare);

            
        }
    insert newAccountShares;
        
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
    public class WrapClass{
     String Old_UserID;
     String AccountID; 
    String New_UserId;
         public WrapCLass(){
             Old_UserID='';
            AccountID =''; 
New_UserId='';
         }
    }
}