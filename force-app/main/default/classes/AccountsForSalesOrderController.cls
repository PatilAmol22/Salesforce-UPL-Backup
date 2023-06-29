public with sharing class AccountsForSalesOrderController {
    /* public AccountsForSalesOrderController() {

    } */
    

    @AuraEnabled
    public static String getLoginUserDetails(String user_id){
      
        String country='';
        try {
        
            User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId FROM User where Id =:user_id];

            if(user != null){
                Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

                if(logCntry != null){
                    country = logCntry.For_Contry__c;
                }
            }
        
        } 
        catch (Exception ex) {
                System.debug('Exception in getLoginUserDetails method...:- '+ ex);
        }
                
        return country;
    }

    @AuraEnabled
    public static List<List<Account>> getAccountList(String user_id){

        List<Account> accList = new List<Account>();
        List<List<Account>> nestedListAccount = new List<List<Account>>();
        String grpCode = '';

        User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId, ProfileId, Profile.Name,UserRole.Name FROM User where Id =: user_id];
        
        if(user.Country == 'Vietnam'){
            if(user.Profile.Name == 'Vietnam Regional Sales Manager(RSM)'){
                accList = [SELECT Id, Name, RecordTypeId, RecordType.name, Type, OwnerId, Distributor_Type__c, 
                       Account_Type__c, Division__c, Distribution_Channel__c, Sales_Org__c, Customer_Grp__r.Customer_Group_Code__c, 
                       Status__c, Active__c FROM Account where RecordType.name = 'Distributor' 
                       AND Account_Type__c = 'Sold To Party' AND Customer_Grp__r.Customer_Group_Code__c = '76' order by Name];
            }
            else { /* if(user.Profile.Name == 'Vietnam Sales Manager(B2B)') */
                accList = [SELECT Id, Name, RecordTypeId, RecordType.name, Type, OwnerId, Distributor_Type__c, 
                       Account_Type__c, Division__c, Distribution_Channel__c, Sales_Org__c, Customer_Grp__r.Customer_Group_Code__c, 
                       Status__c, Active__c FROM Account where RecordType.name = 'Distributor' 
                       AND Account_Type__c = 'Sold To Party' AND Customer_Grp__r.Customer_Group_Code__c = '75' order by Name];
            }

        }
        //Description : Added new profile created for partner licence for Poland as part of Lia Migration
        //Changes Done by : Vijaylaxmi 
        
       else if (user.Country == 'Poland' && user.Profile.Name != 'Customer Community Plus User - Poland - 1' && user.Profile.Name != 'Customer Community Plus User - Poland - 2' && user.Profile.Name != 'Customer Partner Community Plus User - Poland - 1' && user.Profile.Name != 'Customer Partner Community Plus User - Poland - 2') {
           if(User.UserRole.Name != 'Wholesale Sales Manager poland' && User.UserRole.Name != 'Retail Sales Manager' && User.UserRole.Name != 'Non Crop Product Manager' && User.UserRole.Name != 'Sales Manager Poland') {
               accList = [SELECT Id, Name, RecordTypeId, RecordType.name, Type, OwnerId, Distributor_Type__c, LastModifiedDate,  
                       Account_Type__c, Division__c, Distribution_Channel__c, Sales_Org__c, Customer_Grp__r.Customer_Group_Code__c,
                       Status__c, Active__c FROM Account where RecordType.name = 'Distributor' 
                       AND Account_Type__c = 'Sold To Party' AND Sales_Org_Code__c = '2941' AND OwnerId =: user_id  ORDER BY Name ASC, LastModifiedDate DESC LIMIT 45000];
           }
           else{
               accList = [SELECT Id, Name, RecordTypeId, RecordType.name, Type, OwnerId, Distributor_Type__c, LastModifiedDate,  
                       Account_Type__c, Division__c, Distribution_Channel__c, Sales_Org__c, Customer_Grp__r.Customer_Group_Code__c,
                       Status__c, Active__c FROM Account where RecordType.name = 'Distributor' 
                       AND Account_Type__c = 'Sold To Party' AND Sales_Org_Code__c = '2941' ORDER BY Name ASC, LastModifiedDate DESC LIMIT 45000];
           }
            
        }
        else{
            accList = [SELECT Id, Name, RecordTypeId, RecordType.name, Type, OwnerId, Distributor_Type__c, LastModifiedDate,  
                       Account_Type__c, Division__c, Distribution_Channel__c, Sales_Org__c, Customer_Grp__r.Customer_Group_Code__c,
                       Status__c, Active__c FROM Account where RecordType.name = 'Distributor' 
                       AND Account_Type__c = 'Sold To Party' ORDER BY Name ASC, LastModifiedDate DESC LIMIT 45000];
        }                
        
        
        if(accList.size()>0){
                  
            Integer count = 0,index=0;
            System.debug('nestedListAccount');
            List<Account>asts = new List<Account>();
            if(accList.size()<999){
                nestedListAccount.add(accList);
            }
            for(Account acc : accList){
                count++;
            
                if(count>=999){
                        System.debug('count - '+count);
                    nestedListAccount.add(asts);  
                    asts= new List<Account>();
                    index++;
                    count=0; 
                }
                asts.add(acc);
                            
            }
        }          
                
        return nestedListAccount;
    }
}