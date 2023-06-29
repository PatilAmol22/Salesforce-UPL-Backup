public class UI_UX_InterfaceController {
    
    @AuraEnabled
    public static AccountContactListWrapper fetchDatas(String accId){
        AccountContactListWrapper accObject= new AccountContactListWrapper();
        try{
            
            Account accObj =[select Id, Name,SAP_Code__c,PriceGroupCode__r.Name,Brazil_Depot_Code__r.Name from Account where Id=:accId];
            List<Credit_Info__c> creditInfoList=new List<Credit_Info__c>();
            creditInfoList=[select Id,Credit_Limit__c,Internal_Limit__c,Used_Limit__c,Balance_Limit__c,Name from Credit_Info__c
                            where Distributor__c=:accId];
            List<Outstanding_Ageing__c> outstandingAgeingList= new List<Outstanding_Ageing__c>();
            outstandingAgeingList=[select Id, Net_Outstanding__c from Outstanding_Ageing__c where Customer_Code__c=:accId];
                
             List<Payments__c> netOverdueList= new List<Payments__c>();
            netOverdueList= [select Id, Net_Overdue__c from Payments__c where Customer_Name__c=:accId];
            
            
            Decimal totalCreditlimit= 0.0;
            Decimal totalInternalLimit= 0.0;
            Decimal totalUsedlimit= 0.0;
            Decimal totalCreditbalancelimit= 0.0;
            Decimal totalOutstandingAgeing= 0.0;
            Decimal totalNetOverdue= 0.0;
            
            for(Credit_Info__c tempObj :creditInfoList){
                totalCreditlimit = totalCreditlimit + tempObj.Credit_Limit__c;
                totalInternalLimit = totalInternalLimit + tempObj.Internal_Limit__c;
                totalUsedlimit = totalUsedlimit + tempObj.Used_Limit__c;
                totalCreditbalancelimit = totalCreditbalancelimit + tempObj.Balance_Limit__c;
              
            }
            for(Outstanding_Ageing__c tempObj :outstandingAgeingList){
                totalOutstandingAgeing = totalOutstandingAgeing + tempObj.Net_Outstanding__c;
                
            }
            for(Payments__c tempObj :netOverdueList){
                totalNetOverdue = totalNetOverdue + tempObj.Net_Overdue__c;
                
            }
                
            
            //System.debug('totalCreditlimit ' + totalCreditlimit);
            
            accObject.customerSAPCode=accObj.SAP_Code__c;
            accObject.priceGroup=accObj.PriceGroupCode__r.Name;
            accObject.depot =accObj.Brazil_Depot_Code__r.Name;
            
            
            accObject.totalCreditLimit=totalCreditlimit;
            accObject.internalCreditLimit=totalInternalLimit;
            accObject.creditLimitUsed=totalUsedlimit;
            accObject.creditLimitBalance=totalCreditbalancelimit;
            accObject.totalOutstanding=totalOutstandingAgeing;
            accObject.netOverdue=totalNetOverdue;
        }
        catch(Exception ex){
            System.debug('Error Occured Line Number '+ex.getLineNumber());
            System.debug('Error Occured Line Number '+ex.getMessage());
        }
        
        return accObject;
        
    }  
    public class AccountContactListWrapper{
        
        @AuraEnabled public String customerSAPCode{get;set;}
        @AuraEnabled public String priceGroup{get;set;}
        @AuraEnabled public String depot{get;set;}
        @AuraEnabled public Decimal totalCreditLimit{get;set;}
        @AuraEnabled public Decimal internalCreditLimit{get;set;}
        @AuraEnabled public Decimal creditLimitUsed{get;set;}
        @AuraEnabled public Decimal creditLimitBalance{get;set;}
        @AuraEnabled public Decimal totalOutstanding{get;set;}
        @AuraEnabled public Decimal netOverdue{get;set;}
        
        
    }
    
}