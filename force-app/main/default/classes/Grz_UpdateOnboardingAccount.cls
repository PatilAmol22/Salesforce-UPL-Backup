/**************************************************************************************************
* Name             : Grz_UpdateOnboardingAccount                                                     
* Description      : Update onboarded account information from latest sales area
* Created Date     : 24-01-2022                                                                        
* Project/JIRA     : APPS-2665
* Created By       : Sumit Kumar (Grazitti)                                                                        
* Last Modified By : Sumit Kumar (Grazitti) 20-01-2022                                                                      
**************************************************************************************************/

public class Grz_UpdateOnboardingAccount {
	
    Public static void UpdateAccountFromSalesArea(Id SalesAreaId){
       try {
        	List<DistributorSalesAreaMapping__c> salesAreaList = [SELECT Id, Name, Distributor__c,Distributor__r.Payment_Term_Code__c,Distributor__r.Division__c,Distributor__r.Division_Code__c,Distributor__r.Distribution_Channel__c,Distributor__r.PriceGroupCode__c,Distributor__r.Price_List_Type__c,Distributor__r.Sales_Org__c,Distributor__r.Territory_Code__c,Distributor__r.Status__c,DistributionChannel__c, Division__c,PriceGroupMaster__c,PrIceListTypeMaster__c,SalesAreaCode__c, SalesOrg__c, Status__c,SalesOrg__r.name, AccountType__c, Division_Code__c, Territory__c,Payment_Term__c FROM DistributorSalesAreaMapping__c where Id =: SalesAreaId];
        	system.debug('salesAreaList : '+salesAreaList);
           List<Account> accTOUpdate = new List<Account>();
           for(DistributorSalesAreaMapping__c sa : salesAreaList){
                Account acc = new account(Id = sa.Distributor__c);
                acc.Division__c = sa.Division__c;
                acc.Division_Code__c = sa.Division_Code__c;
                acc.Distribution_Channel__c = sa.DistributionChannel__c;
                acc.PriceGroupCode__c = sa.PriceGroupMaster__c;
                acc.Price_List_Type__c = sa.PrIceListTypeMaster__c;
                acc.Sales_Org__c = sa.SalesOrg__c;
                acc.Territory_Distributor__c = sa.Territory__c;
                if(sa.SalesOrg__r.name == 'India'){
                	acc.Status__c = 'Active'; 
                }
                else if(sa.SalesOrg__r.name == 'UPL SAS'){
                    acc.Status__c = 'Active';
                }
                else if(sa.SalesOrg__r.name == 'SWAL'){
                    acc.Status__c = 'SWAL Active';
                }
                else if(sa.SalesOrg__r.name == 'ALS India'){
                    acc.Status__c = 'ALS Active';
                }
                accTOUpdate.add(acc);
               acc.Payment_Term_Code__c=sa.Payment_Term__c;
            }
           	system.debug('accTOUpdate : '+accTOUpdate);
           if(accTOUpdate.size() > 0){
               update accTOUpdate;
           }
           //salesAreaList.Distributor__r.Division__c = salesAreaList.Division__c;
           //update salesAreaList.Distributor__c;
       }
        catch(Exception e) {
    		System.debug('An unexpected error has occurred: ' + e.getMessage());
		}       
    }
}