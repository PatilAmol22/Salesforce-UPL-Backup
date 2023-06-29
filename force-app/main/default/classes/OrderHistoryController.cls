public class OrderHistoryController {

    public date startdate {get;set;}
    public date enddate {get;set;}
    public String liststring {get;set;}
    public User loginUserObj {get;set;}
    public List<Contact> conList {get;set;}
    public Id AccountId {get;set;}
    public List<Sales_Order__c> displayList {get;set;}
    
    public orderhistorycontroller(){
        displayList = new List<Sales_Order__c>();
        liststring = 'Last 10 Orders';
        loginUserObj = [SELECT Id, Name, IsActive, ContactId
                            FROM User WHERE Id =: UserInfo.getUserId() AND IsActive = True];
                            
        //Assign Account Id based on Logged In User            
        conList = [SELECT Id, FirstName, LastName, Accountid, Account.OwnerId, Account.RegionalManager__c
                   FROM Contact WHERE Id =: loginUserObj.ContactID];
        
        /*if(conObj.Accountid!=null){
            AccountId = conObj.Accountid;
        }else{
            AccountId = '001N000000qg8AT';
        }*/
        if(!conList.isEmpty()){        
            accountId = conList[0].Accountid;
            //territoryManagerId = conList[0].Account.OwnerId;      
        }
      /*  else{
            accountId = '001N000000qg8AT';
            //depoId = 'a0wN0000002zYrxIAE';
            //territoryManagerId = '005N0000002kOef';
        }*/

        displayList = [Select Id, Name, Order_Date__c, Sold_to_Party__c, Status__c, Total_Amount__c, Order_Cancel__c 
                        From Sales_Order__c Where Sold_to_Party__c =: AccountId AND Order_Cancel__c =: false 
                        Order By Order_Date__c DESC Limit 10];
    }
    
    public void searchdata(){
        liststring = 'Search Result';
        
        displayList = [Select Id, Name, Order_Date__c, Sold_to_Party__c, Status__c, Total_Amount__c, Order_Cancel__c 
                        From Sales_Order__c Where Sold_to_Party__c =: AccountId AND Order_Cancel__c =: false AND Order_Date__c>=:startdate AND Order_Date__c<=:enddate
                        Order By Order_Date__c DESC Limit 10];
    }
    
    /*
     *  toHome() 
     *  navigates to the Home page 
     */
    public PageReference toHome() {
        PageReference next = new PageReference('/apex/cataloghome');
        next.setRedirect(true);
        // Directing to Home
        return next;
    }    
}