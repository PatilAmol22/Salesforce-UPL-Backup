/**************************************************************************************************
* Name               : Grz_AccountReceivableReportController                                                      
* Description        : Controller class for grz_AccountReceivableReport aura Component
* Test Class         : Grz_AccountReceivableControllerTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_AccountReceivableReportController {
/**************************************************************************************************
* Name               : getuserInfo                                                      
* Description        : Method will return values for filter
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled
    public static ResultWrapper getuserInfo(){
        Id id;
        if(Test.isRunningTest()){
            List<Profile> pro = [SELECT Id FROM Profile WHERE Name = 'Brazil Partner Community Distributor Profile'];
            List<User> user = [SELECT Id, Username, AccountId, ContactId FROM User WHERE ProfileId =: pro[0].Id AND lastname = 'Testing' and Email ='test@grazitti.com' LIMIT 1];
            id = user[0].Id;
        }
        else{
            id = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, Username, AccountId, ContactId,Account.Customer_Group__c,Account.SAP_Customer_Code__c,Account.Name,Account.BillingCity,Account.Company_Code__c ,Account.Sap_UserId__c FROM User where Id =: id];
        String groupCstr = user[0].Account.Customer_Group__c;
        String accountId = user[0].AccountId;
        List<String> cstrCode = new List<String>();
        Map<String,String> cstCity = new Map<String,String>();
        //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        Boolean isMainParent = false;
        Set<String> subGroupData = new Set<String>();

        if(!user.isEmpty()){
            cstCity.put(user[0].Account.SAP_Customer_Code__c , user[0].Account.BillingCity);
            cstrCode.add(user[0].Account.SAP_Customer_Code__c + ' - '+ user[0].Account.Name + ' - ' + user[0].Account.BillingCity);
        }
        Set<Id> accId = new Set<Id>();
        if(!String.isEmpty(groupCstr)){
            for(Account ac : [SELECT Id,Name,BillingCity,SAP_Customer_Code__c FROM Account where Customer_Group__c =:groupCstr AND (ParentId =:accountId OR Sub_Parent_Account__c =: accountId) ORDER BY Name, BillingCity ASC] ){//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                accId.add(ac.Id);
                cstrCode.add(ac.SAP_Customer_Code__c + ' - '+ ac.Name + ' - ' + ac.BillingCity);
                cstCity.put(ac.SAP_Customer_Code__c , ac.BillingCity);
            }
            //Query added to get Sub Group distributor data, Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            for (Account ac : [SELECT Id, Sub_Parent_Account__c, Sub_Parent_Account__r.Name, Sub_Parent_Account__r.BillingCity, Sub_Parent_Account__r.SAP_Customer_Code__c
                               FROM Account
                               WHERE Customer_Group__c = :groupCstr AND ParentId = :accountId AND Sub_Parent_Account__c != null
                               ORDER BY Sub_Parent_Account__r.Name ASC]){
                                   isMainParent = true;
                                   subGroupData.add(ac.Sub_Parent_Account__r.SAP_Customer_Code__c + ' - ' + ac.Sub_Parent_Account__r.Name + ' - ' + ac.Sub_Parent_Account__r.BillingCity);
                               }
        }
        accId.add(accountId);
        ResultWrapper rapper = new ResultWrapper();
        rapper.customerCode = user[0].Account.SAP_Customer_Code__c;
        rapper.companyCode = user[0].Account.Company_Code__c;
        rapper.sapUserId = user[0].Account.Sap_UserId__c;
        if(accId.size() > 1){
          rapper.isParentBr = true;
          rapper.cstrCode = cstrCode;
        }else{
          rapper.isParentBr = false;
        }
        //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        if (isMainParent){
            rapper.subGroupData = subGroupData;
            rapper.isMainParent = true;
        }
        return rapper; 
      }

/**************************************************************************************************
* Name               : getAccountReceivables                                                      
* Description        : Method will return Account Receivables data via API callout from SAP to generate Pie graph
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
    @AuraEnabled
    public static ResultWrapper getAccountReceivables(String customerCode, String sapUserId, String companyCode, String distributorValue, String subGroupId){
        ResultWrapper rapper = new ResultWrapper();
     DateTime todaysDate = System.today();
      DateTime today0_30 = todaysDate + 30;
      DateTime today31_60 = today0_30 + 30;
      //String todaysDateStr = todaysDate.format('yyyy-MM-dd');
      //String todaysDateStr1 = today0_30.format('yyyy-MM-dd');
      //String todaysDateStr2 = today31_60.format('yyyy-MM-dd');
      Date todaysDateStr = todaysDate.dateGMT();
      Date todaysDateStr1 = today0_30.dateGMT();
      Date todaysDateStr2 = today31_60.dateGMT();
      system.debug('==================================');
      system.debug('todayDatestr==>'+todaysDateStr);
      //system.debug('todayDateGMT==>'+todaysDate.dateGMT());
      system.debug('==================================');
      system.debug('today0_30str==>'+todaysDateStr1);
      //system.debug('today0_30GMT==>'+today0_30.dateGMT());
      system.debug('==================================');
      system.debug('today31_60str==>'+todaysDateStr2);
      //system.debug('today31_60GMT==>'+today31_60.dateGMT());
        String res;
        Set<String> subGroupSapId = new Set<String>();
        if(!String.isEmpty(distributorValue)) {
            if(distributorValue != 'All'){
              res = grz_SapIntegration.getBrazilAccountReceivables(distributorValue,sapUserId,companyCode,String.ValueOf(todaysDateStr));
            }else{//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (subGroupId != null && subGroupId != ''){
                    for(Account acc : [SELECT SAP_Code__c FROM Account WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId ]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                }
              res = grz_SapIntegration.getBrazilAccountReceivables(customerCode,sapUserId,companyCode,String.ValueOf(todaysDateStr));
            }
          }
        res = res.replace('"date":','"dueDate":');
        if(res.equals('Error_In_Sap')){
            rapper.isSuccess = false;
            rapper.Message = 'Não há dados disponíveis';
        }
        else{
            rapper.isSuccess = true;
            rapper.ar = (Br_Account_receivable) JSON.deserialize(res, Br_Account_receivable.class); 
            rapper.totalOverdue = 0;
            rapper.upto_0_30 = 0;
            rapper.upto_31_60 = 0;
            rapper.after_61 = 0;
            //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            for(ARWrapper ifo : rapper.ar.Account_Receivables){
                if (distributorValue != customerCode){
                    if(!subGroupSapId.isEmpty()){
                      if(subGroupSapId.contains(ifo.customer_number)){
                        if(date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr)){
                            rapper.totalOverdue += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr1)){
                            rapper.upto_0_30 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr1)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr2)){
                            rapper.upto_31_60 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr2)){
                            rapper.after_61 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                      }
                    }else{
                        if(date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr)){
                            rapper.totalOverdue += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr1)){
                            rapper.upto_0_30 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr1)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr2)){
                            rapper.upto_31_60 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr2)){
                            rapper.after_61 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                    }
                }else{
                    if (ifo.customer_number == distributorValue){
                        if(date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr)){
                            rapper.totalOverdue += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr1)){
                            rapper.upto_0_30 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr1)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr2)){
                            rapper.upto_31_60 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr2)){
                            rapper.after_61 += decimal.valueOf(ifo.account_in_local_currency);
                        }
                    }
                }
            }
            //End------Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            List<ARData> arData = new List<ARData>();
            arData.add(new ARData('Vencida',rapper.totalOverdue)); 
            arData.add(new ARData('0 a 30 dias',rapper.upto_0_30));
            arData.add(new ARData('De 31 a 60 dias',rapper.upto_31_60));
            arData.add(new ARData('Maior que 60 dias',rapper.after_61));
            rapper.ARWrap = arData; 
        }
        return rapper;
    }
    public class ARData {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal value {get; set;}
        public ARData(String name, Decimal value) {
            this.name = name;
            this.value = value;
        }
    }
    public class ResultWrapper {        
        @AuraEnabled public decimal totalOverdue { get; set; }
        @AuraEnabled public decimal upto_0_30 { get; set; }
        @AuraEnabled public decimal upto_31_60 { get; set; }
        @AuraEnabled public decimal after_61 { get; set; }
        @AuraEnabled public Br_Account_receivable ar { get; set; }
        @AuraEnabled public boolean isSuccess{get;set;}
        @AuraEnabled public String Message{get;set;}
        @AuraEnabled public list<ARData> ARWrap{get;set;}
        @AuraEnabled public Boolean isParentBr{get;set;} 
        @AuraEnabled public List<String> cstrCode{get;set;} 
        @AuraEnabled public String customerCode { get; set; }
        @AuraEnabled public String sapUserId { get; set; }
        @AuraEnabled public String companyCode { get; set; }
        @AuraEnabled public Boolean isMainParent{ get; set; }
        @AuraEnabled public Set<String> subGroupData{ get; set; }
    }
    public class Br_Account_receivable{
        @AuraEnabled public List<ARWrapper> Account_Receivables {get;set;}
    }
    public class ARWrapper {
        @AuraEnabled public String customer_number{get;set;}
        @AuraEnabled public String dueDate{get;set;}
        @AuraEnabled public String account_in_local_currency{get;set;}
    }
}