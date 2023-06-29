/*
* Name: BrazilAccountShare
* Created On: 22 November 2017
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Apex Class to get Accounts with Sharing (Called from OrderRequestController - Brazil)
*/
public with sharing class BrazilAccountShare {
    
    public static Map<Id,Account> getKeyCustomers(String userId, String orderType, String customerGroup, String accountId){
        
        List<Customer_and_Region_Mapping__c> crmList = new List<Customer_and_Region_Mapping__c>();
        
        //Reduce 18 digit Salesforce Id to 15 digits.
        if(String.isNotBlank(userId)){
            userId = userId.substring(0, userId.length() - 3);
        }
        
        //Get customer with same account ID in case of mother/child order. For ex: '001'
        if(customerGroup=='001'||customerGroup=='1'){
            
            crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
                       SAP_Code__c, BillingCity__c,
                       Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
                       Customer_Region__c, Customer_Group__c,
                       Program_Margin_Discount__c
                       FROM Customer_and_Region_Mapping__c
                       WHERE (TerritoryManager__c =:userId
                       OR SalesDistrictManagerID__c =:userId
                       OR SalesOfficeManagerID__c =:userId       
                       OR SalesDirectorID__c =:userId)
                       AND Sales_Org_Country__c='Brazil' 
                       AND Customer_Name__c=:accountId 
                       AND Account_Active__c=True 
                       AND Active__c=True
                       AND Customer_Group__c!=''];
        }
        
        //Get customer with same customer groups. For ex: '005'
        else if(orderType == 'ORDEM FILHA'){
            
            crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
                       SAP_Code__c, BillingCity__c,
                       Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
                       Customer_Region__c, Customer_Group__c,
                       Program_Margin_Discount__c
                       FROM Customer_and_Region_Mapping__c
                       WHERE (TerritoryManager__c =:userId
                       OR SalesDistrictManagerID__c =:userId
                       OR SalesOfficeManagerID__c =:userId       
                       OR SalesDirectorID__c =:userId)
                       AND Sales_Org_Country__c='Brazil' 
                       AND Customer_Group__c=:customerGroup 
                       AND Account_Active__c=True 
                       AND Active__c=True
                       AND Customer_Group__c!=''];
        }
        
                else if(orderType == 'BONIFICAÇÃO' && customerGroup != null && customerGroup != '') { //added by Aditya@wipro for Bonification Order
            crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
                       SAP_Code__c, BillingCity__c,
                       Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
                       Customer_Region__c, Customer_Group__c,
                       Program_Margin_Discount__c
                       FROM Customer_and_Region_Mapping__c
                       WHERE (TerritoryManager__c =:userId
                       OR SalesDistrictManagerID__c =:userId
                       OR SalesOfficeManagerID__c =:userId       
                       OR SalesDirectorID__c =:userId)
                       AND Sales_Org_Country__c='Brazil' 
                       AND Customer_Group__c=:customerGroup
                       AND Account_Active__c=True 
                       AND Active__c=True
                       AND Customer_Group__c!=''];
        }

        //Get customer with non empty customer groups for Mother/Child Orders
        else if(orderType == 'CONTRATO MÃE'){
            
            crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
                       SAP_Code__c, BillingCity__c,
                       Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
                       Customer_Region__c, Customer_Group__c,
                       Program_Margin_Discount__c
                       FROM Customer_and_Region_Mapping__c
                       WHERE (TerritoryManager__c =:userId
                       OR SalesDistrictManagerID__c =:userId
                       OR SalesOfficeManagerID__c =:userId       
                       OR SalesDirectorID__c =:userId)
                       AND Sales_Org_Country__c='Brazil'
                       AND Active__c=True
                       AND Account_Active__c=True];
        }
        
        //Get customer with empty customer groups for all other order types (Normal, Bonificaco, etc....)
        else{
            
            crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
                       SAP_Code__c, BillingCity__c,
                       Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
                       Customer_Region__c, Customer_Group__c,
                       Program_Margin_Discount__c
                       FROM Customer_and_Region_Mapping__c
                       WHERE (TerritoryManager__c =:userId
                       OR SalesDistrictManagerID__c =:userId
                       OR SalesOfficeManagerID__c =:userId       
                       OR SalesDirectorID__c =:userId)
                       AND Sales_Org_Country__c='Brazil'
                       AND Account_Active__c=True
                       AND Active__c=True
                       AND Customer_Group__c!='']; 
            System.debug('crmList: '+crmList);
        }
        
        System.debug('crmList: '+crmList);
        //Change by Nikhil(Grazitti)-INC0373530-6th Sept
        Map<Id,Account> accountList = new Map<Id,Account>();
        for(Customer_and_Region_Mapping__c crmObj:crmList){
            Account accObj = new Account();
            accObj.Id = crmObj.Customer_Name__c;
            accObj.Name = crmObj.Customer_Name__r.Name;
            accObj.SAP_Code__c = crmObj.SAP_Code__c;
            accObj.BillingCity = crmObj.BillingCity__c;
            accObj.Depot_Code__c = crmObj.Depot_Code__c;
            accObj.Tax_Number_3__c = crmObj.Tax_Number_3__c;
            accObj.Tax_Number_1__c = crmObj.Tax_Number_1__c;
            accObj.Customer_Region__c = crmObj.Customer_Region__c;
            accObj.Customer_Group__c = crmObj.Customer_Group__c;
            accObj.Program_Margin_Discount__c = crmObj.Program_Margin_Discount__c; 
             accObj.Key_Account_Manager__c = crmObj.Key_Account_Manager__c;
            accountList.put(accObj.Id,accObj);
        }
        //Change by Nikhil(Grazitti)-INC0373530-6th Sept
        return accountList;
    }

    // Added below method for Brazil Sales District Manager to fetch Account on basis of regionCode GRZ(Nikhil Verma) INC0385117 date: 06-10-2022
    public static Map<Id,Account> getKeyCustomersForSDM(String customerRegionCode, String customerGroup  ){
        Map<Id,Account> accountList = new Map<Id,Account>();
        List<Customer_and_Region_Mapping__c> crmList = new List<Customer_and_Region_Mapping__c>();

        system.debug('customerRegionCode'+customerRegionCode);
        system.debug('customerGroup'+customerGroup);
        // Added Below condition by GRZ(Dheeraj Sharma) for INC0479142 on 25-05-2023
       if(customerGroup!=null  && customerRegionCode!=null){
        crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
        SAP_Code__c, BillingCity__c,
        Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
        Customer_Region__c, Customer_Group__c,
        Program_Margin_Discount__c
        FROM Customer_and_Region_Mapping__c
        WHERE CustomerRegionCode__c =:customerRegionCode AND Customer_Group__c =:customerGroup]; 
       }else{
        crmList = [SELECT Id, Customer_Name__c, Customer_Name__r.Name,Key_Account_Manager__c,
        SAP_Code__c, BillingCity__c,
        Depot_Code__c, Tax_Number_3__c, Tax_Number_1__c,
        Customer_Region__c, Customer_Group__c,
        Program_Margin_Discount__c
        FROM Customer_and_Region_Mapping__c
        WHERE CustomerRegionCode__c =:customerRegionCode]; 
       }
        // Added End condition by GRZ(Dheeraj Sharma) for INC0479142 on 25-05-2023
        
        for(Customer_and_Region_Mapping__c crmObj : crmList){
            Account accObj = new Account();
            accObj.Id = crmObj.Customer_Name__c;
            accObj.Name = crmObj.Customer_Name__r.Name;
            accObj.SAP_Code__c = crmObj.SAP_Code__c;
            accObj.BillingCity = crmObj.BillingCity__c;
            accObj.Depot_Code__c = crmObj.Depot_Code__c;
            accObj.Tax_Number_3__c = crmObj.Tax_Number_3__c;
            accObj.Tax_Number_1__c = crmObj.Tax_Number_1__c;
            accObj.Customer_Region__c = crmObj.Customer_Region__c;
            accObj.Customer_Group__c = crmObj.Customer_Group__c;
            accObj.Program_Margin_Discount__c = crmObj.Program_Margin_Discount__c; 
            accObj.Key_Account_Manager__c = crmObj.Key_Account_Manager__c;
            accountList.put(accObj.Id,accObj);
        }
        return accountList;
    }
    //----------------End GRZ(Nikhil Verma) INC0385117--------------------------

    /*public static List<Account> getCustomers(String orderType, String customerGroup, String accountId){
        
        //Get customer with same account ID in case of mother/child order. For ex: '001'
        if(customerGroup=='001'||customerGroup=='1'){
            
            return [SELECT Id, Name, SAP_Code__c, BillingCity, Depot_Code__c, Tax_Number_3__c,
                    Customer_Region__c, Customer_Group__c, Program_Margin_Discount__c 
                    FROM Account 
                    WHERE Sales_Org_Country__c='Brazil' AND Id=:accountId 
                    AND Active__c=True AND Customer_Group__c!=''];
        }
        
        //Get customer with same customer groups. For ex: '005'
        else if(orderType == 'ORDEM FILHA'){
            
            return [SELECT Id, Name, SAP_Code__c, BillingCity, Depot_Code__c, Tax_Number_3__c,
                    Customer_Region__c, Customer_Group__c, Program_Margin_Discount__c 
                    FROM Account 
                    WHERE Sales_Org_Country__c='Brazil' 
                    AND Customer_Group__c=:customerGroup 
                    AND Active__c=True AND Customer_Group__c!='']; 
        }
        
        //Get customer with non empty customer groups for Mother/Child Orders
        else if(orderType == 'CONTRATO MÃE'){
            
            return [SELECT Id, Name, SAP_Code__c, BillingCity, 
                    Tax_Number_3__c, Program_Margin_Discount__c, 
                    Customer_Region__c, Customer_Group__c, Depot_Code__c
                    FROM Account 
                    WHERE Sales_Org_Country__c='Brazil' 
                    AND Active__c=True 
                    AND Customer_Group__c!=''];
        }
        
        //Get customer with empty customer groups for all other order types (Normal, Bonificaco, etc....)
        else{
            
            return [SELECT Id, Name, SAP_Code__c, BillingCity, 
                    Depot_Code__c, Tax_Number_3__c, Customer_Region__c,
                    Customer_Group__c, Program_Margin_Discount__c 
                    FROM Account 
                    WHERE Sales_Org_Country__c='Brazil' 
                    AND Active__c=True];  
        }        
    }*/
}