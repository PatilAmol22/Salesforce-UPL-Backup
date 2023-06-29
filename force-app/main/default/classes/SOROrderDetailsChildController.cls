/*******************************************************************************************
* @Name         Sales Order Return 
* @Author       Nikhil Dhoke (SKI)
* @Date         03/03/2023
* @Group        SKI
* @Description  This class is used for Sales Order Return Module (Brazil Only).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer         	   Date(MM/DD/YYYY)      Description
*-------------------------------------------------------------------------------------------   
*  1.0             Nikhil Dhoke            03/04/2023            Initial Creation                                        
*******************************************************************************************/
public without sharing class SOROrderDetailsChildController {
    /* public SOROrderDetailsChildController() {

    } */

    /*
    * @Description - This method will return Sub return types bsed on return type.
    * @Param String - return type.
    * @return  - List of Sub return types.
    */
    @AuraEnabled(cacheable=true)
    public static List<OptionsWrapper> getSubReturnTypes(String rtrnType){
        List<OptionsWrapper> optionList = new List<OptionsWrapper>();
        try {
            List<RSO_Return_Sub_Status__c> subTypes = [SELECT Id, Name, Return_Type__c, Sub_Return_Type__c, Sub_Return_Type_Code__c  
                                                        FROM RSO_Return_Sub_Status__c  WHERE Return_Type__c =: rtrnType];
            if(subTypes.size()>0){
                for(RSO_Return_Sub_Status__c rsoRSS : subTypes){
                    OptionsWrapper opWrap = new OptionsWrapper();
                    opWrap.id = rsoRSS.Id;
                    opWrap.name = rsoRSS.Name;
                    opWrap.returnType = rsoRSS.Return_Type__c;
                    opWrap.subReturnType = rsoRSS.Sub_Return_Type__c;
                    opWrap.code = rsoRSS.Sub_Return_Type_Code__c;

                    optionList.add(opWrap);
                }
            }

        } catch (Exception e) {
            System.debug('getSORDetails Exception is - '+ e.getMessage());
            System.debug('getSORDetails Exception at - '+ e.getLineNumber());
        }
        return optionList;
    }

    /*
    * @Description - This method will return wrapper object with rebabte contract, Region and district details.
    * @Param String - customer region id(Customer and Region object id).
    * @return  - wrapper object.
    */
    @AuraEnabled(cacheable=true)
    public static OrderDetailsWrapper getRebateRegionDistrict(String custRegnId){
        String accId = '';
        OrderDetailsWrapper str = new OrderDetailsWrapper();
        try {
            List<Customer_and_Region_Mapping__c> custRegList = [SELECT Id, Name, Active__c, Account_Active__c, 
                                                                Customer_Name__c, CustomerRegion__c, 
                                                                CustomerRegion__r.Name, CustomerRegion__r.TerritoryCode__c, 
                                                                CustomerRegion__r.Region__c, CustomerRegion__r.Region__r.Name, 
                                                                CustomerRegion__r.Region__r.RegionCode__c 
                                                                FROM Customer_and_Region_Mapping__c WHERE 
                                                                Id =: custRegnId ORDER BY LastModifiedDate DESC LIMIT 1];
            if(custRegList.size()>0){
                accId = custRegList[0].Customer_Name__c;
                str.accountId = custRegList[0].Customer_Name__c;
                str.distTerId = custRegList[0].CustomerRegion__c;
                str.terId = custRegList[0].CustomerRegion__c;
                str.region = custRegList[0].CustomerRegion__r.Name +'-'+ custRegList[0].CustomerRegion__r.TerritoryCode__c;
                str.regnId = custRegList[0].CustomerRegion__r.Region__c;
                str.district = custRegList[0].CustomerRegion__r.Region__r.Name +'-'+custRegList[0].CustomerRegion__r.Region__r.RegionCode__c;
            }  

            if(accId.length() > 0){
                List<Rebate_Contract__c> rebList = SOROrderDetailsChildController.getRebateContract(accId);            
                if(rebList.size()>0){
                    str.rebContractName = rebList[0].Name;
                    str.rebContractId = rebList[0].Id;
                }   
            }
                                

        } catch (Exception e) {
            System.debug('getRebateRegionDistrict Exception is - '+ e.getMessage());
            System.debug('getRebateRegionDistrict Exception at - '+ e.getLineNumber());
        }
        //System.debug('getRebateRegionDistrict - '+ JSON.serializePretty(str));
        return str;
    }

    /*
    * @Description - This method will return rebabte contract for the account.
    * @Param String - account id.
    * @return  - List of Rebate contract.
    */
    @AuraEnabled
    public static List<Rebate_Contract__c> getRebateContract(String accId){
        List<Rebate_Contract__c> rebList = new List<Rebate_Contract__c>();
        try {
           rebList = [SELECT Id, Name, Contract_Number_Formula__c, Distributor__c, 
                        End_Date__c, Sales_Org__c, Status__c, Type__c, LastModifiedDate 
                        FROM Rebate_Contract__c WHERE Distributor__c =: accId 
                        AND Sales_Org__r.Sales_org_code__c='5191' ORDER BY LastModifiedDate DESC LIMIT 1];            
             
        } catch (Exception e) {
            System.debug('getRebateContract Exception is - '+ e.getMessage());
            System.debug('getRebateContract Exception at - '+ e.getLineNumber());
        }
        
        return rebList;
    }

    public class OptionsWrapper{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String returnType;
        @AuraEnabled public String subReturnType;
        @AuraEnabled public String code;

        public OptionsWrapper(){
            id = '';
            name = '';
            returnType = '';
            subReturnType = '';
            code = '';
        }
    }

    public class OrderDetailsWrapper{
        
        @AuraEnabled public String returnOrderNumber;
        @AuraEnabled public String refusal;
        @AuraEnabled public String reInvoicing;
        @AuraEnabled public String dateOfIncident;
        @AuraEnabled public String returnType;
        @AuraEnabled public String returnSubType;
        @AuraEnabled public String subType;
        @AuraEnabled public String status;
        @AuraEnabled public String subStatus;
        @AuraEnabled public String logisticsOperator;
        @AuraEnabled public String creditAnalyst;
        @AuraEnabled public String creditAnalystName;
        @AuraEnabled public String contact;
        @AuraEnabled public String accountId;
        @AuraEnabled public String accountName;
        @AuraEnabled public String rebContractId;
        @AuraEnabled public String rebContractName;
        @AuraEnabled public String profileName;
        @AuraEnabled public String terId;
        @AuraEnabled public String regnId;
        @AuraEnabled public String soNumber;
        @AuraEnabled public String district;
        @AuraEnabled public String region;
        @AuraEnabled public String requester;
        @AuraEnabled public String requesterId;
        @AuraEnabled public String createDate;
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public Boolean isDraft;
        @AuraEnabled public String returnDetails;
        @AuraEnabled public String distTerId;

        public OrderDetailsWrapper(){
            returnOrderNumber = '';
            refusal = '';
            reInvoicing = '';
            dateOfIncident = string.valueof(System.today());
            returnType = '';
            returnSubType = '';
            subType = '';
            status = '';
            subStatus = '';
            logisticsOperator = '';
            creditAnalyst = '';
            creditAnalystName = '';
            contact = '';
            accountId = '';
            accountName = '';
            rebContractId = '';
            rebContractName = '';
            profileName = '';
            terId = '';
            regnId = '';
            soNumber = '';
            district = '';
            region = '';
            requester = UserInfo.getName();
            requesterId = UserInfo.getUserId();
            createDate = string.valueof(System.today());
            isEdit = false;
            isDraft = false;
            returnDetails = '';
            distTerId = '';
        }
    }
}