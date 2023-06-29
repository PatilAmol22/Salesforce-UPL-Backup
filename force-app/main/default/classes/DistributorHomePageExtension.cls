public  class  DistributorHomePageExtension {
public Account distributorObject {get;set;}
public Contact conObj {get;set;}
public User loginUserObj {get;set;}
public List<Sales_Order__c> orderHistoryList {get;set;}
Public List<Credit_Info__c>  creditInfoObject {get;set;}
public Distributor_Depot_Mapping__c dpMapping {get;set;}
Public List<Account_Ledger__c> AccountLedgerList {get;set;}
    public DistributorHomePageExtension(){
       // try{
        loginUserObj = [select id,Name,IsActive, ContactId, AccountId, PortalRole FROM User where id =: UserInfo.getUserId()];
         conObj = [select id, FirstName,LastName,Name, Accountid,Account.name,phone,Account.Owner.Name, MobilePhone, otherPhone, OwnerId,Owner.Phone , MailingCity from Contact where id =: loginUserObj.ContactID];
         distributorObject =[select id, name, CurrencyIsoCode from Account where id=:  loginUserObj.AccountID];
         creditInfoObject = new List<Credit_Info__c>([SELECT Id, Name, Distributor__c, Sales_Org__r.Name,Credit_Limit__c, LastModifiedDate, Used_Limit__c, Balance_Limit__c, Sum_Open_Item__c, Percentage_Used__c FROM Credit_Info__c where Distributor__c =: distributorObject.id  AND Sales_Org__c != Null order by LastModifiedDate desc  ]);
         system.debug('Credit Info :'+ creditInfoObject);
            system.debug('loginUserObj Info :'+ loginUserObj);
         orderHistoryList = new  List<Sales_Order__c>([SELECT Id,Name, CurrencyIsoCode, Net_Amount__c,Tax_Amount__c,Total_Amount__c, Bill_To_Party__c,Sold_to_Party__c, Order_Date__c, Order_Raise_By__c, Order_Status__c, SAP_Order_Number__c, SFDC_Order_Number__c,  RegionalManager__c FROM Sales_Order__c where Sold_to_Party__c =: distributorObject.id  order by CreatedDate desc limit 10] );
         AccountLedgerList = new List<Account_Ledger__c>([select id, name , Customer__c, Doc_Amount__c, Doc_Number__c, Doc_Type__c, Posting_Date__c from Account_Ledger__c where Customer__c =: distributorObject.id limit 10]);
        dpMapping  = [SELECT Id, Name, Depot__r.Name, Distributor__c FROM Distributor_Depot_Mapping__c where Distributor__c =:  distributorObject.id limit 1];
        system.debug('order History List :' + orderHistoryList);
    //    }
   //     catch(Exception e){
   //         system.debug('In Catch Block msg : '+e.getMessage()+e.getLineNumber());
    //    }
    } 
}