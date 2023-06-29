@isTest(seeAllData=False)
public class RebateServiceHelper_Test {
    
    static testMethod void CallGetContract()
    {
        WrapperContractID cntID= new WrapperContractID();
       User usr = TestDataFactory.CreateUser();
        Sales_Org__c sorg;
        system.runAs(usr){
             sorg =TestDataFactory.CreateSalesOrg();
        Account acc = TestDataFactory.CreateAccount('0001033509');
        
        Zone__c zn = TestDataFactory.CreateZone();
        Territory_Distributor__c tr =TestDataFactory.CreateTerritory(zn,usr,sorg) ;
        GetContractRequestWrapper req= new GetContractRequestWrapper();   
        UPL_Settings__c uplsetting= new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Contract_URL__c='www.www.com');  
        insert uplsetting;
        req.companyCode='5190';
        req.contractInitialDate='2019-04-01';
        req.contractFinalDate='2019-04-04';   
        cntID= RebateServiceHelper.getContract(req);
        delete uplsetting;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test');  
        cntID= RebateServiceHelper.getContract(req);
        }
    }

    static testMethod void CallGetGoals()
    {
       User usr = TestDataFactory.CreateUser();
        Sales_Org__c sorg;
        system.runAs(usr){
             sorg =TestDataFactory.CreateSalesOrg();
        SKU__c skuo = TestDataFactory.CreateSKU('000000000006250320',sorg,'000000000006250320');
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Get_Goals_URL__c='www.www.com');  
        string result;
        GetGoalsRequestWrapper reqGoals= new GetGoalsRequestWrapper();
        reqGoals.companyCode='5190';
        reqGoals.contractNumber='10';
        result = RebateServiceHelper.getGoals(reqGoals);
        reqGoals.contractNumber='20';
        result = RebateServiceHelper.getGoals(reqGoals);
        }
    }
    
    static testMethod void CallSendGoals()
    {
        
        UPL_Settings__c us= new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Send_Goals_URL__c='www.www.com');  
        insert us;
         Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        
        SendGoalRequestWrapper send= new SendGoalRequestWrapper();
        send.actionCode= '1';
        send.I_NETOUT='0.00';
        send.userRole='4';   
        send.companyCode='5190';
        send.contractNumber='10';
        send.approverEmail='rafael.chiavenato@upl-ltd.com.invalid';
        send.I_ENVIAR='3';
        send.comments='TEST';
        list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
        SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
        lst.skuCode='000000000006250320';
        lst.volume='10';
        lst.unitPrice='10';
        lstToSend.add(lst);
        SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
        gItem.item= lstToSend;
        send.goals=gItem;
        boolean temp;
        temp=RebateServiceHelper.SendGoals(send);
        system.debug('temp is'+ temp);
        delete us;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test');  
        temp=RebateServiceHelper.SendGoals(send);
        
        system.debug('temp is'+ temp);
       
       
    }
    
     static testMethod void CallGetGoalActuals()
    {
    
        User usr = TestDataFactory.CreateUser();
        Sales_Org__c sorg;
        system.runAs(usr){
             sorg =TestDataFactory.CreateSalesOrg();
        SKU__c skuo = TestDataFactory.CreateSKU('000000000006250320',sorg,'000000000006250320');
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='8';
        rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        UPL_Settings__c uplsetting =new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Get_Goals_URL__c='www.www.com');  
        insert uplsetting;
        GetGoalActualsRequestWrapper reqGoals= new GetGoalActualsRequestWrapper();
        reqGoals.companyCode='5190';
        reqGoals.contractNumber='8';
        Boolean res= RebateServiceHelper.GetGoalActuals(reqGoals);
        delete uplsetting;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Get_Goals_URL__c='www.www.com',Rebate_Get_Actuals_URL__c='www.www.com');  
        res= RebateServiceHelper.GetGoalActuals(reqGoals);
        system.debug('value is '+ res);
        }
    }
    
    
    static testMethod void CallGetApprovalHistory()
    {
        User usr = TestDataFactory.CreateUser();
        Sales_Org__c sorg;
        system.runAs(usr){
             sorg =TestDataFactory.CreateSalesOrg();
        SKU__c skuo = TestDataFactory.CreateSKU('000000000006250320',sorg,'000000000006250320');
        Rebate_Contract__c rebContr = new Rebate_Contract__c();
        rebContr.Combination_Key__c='519010';
        rebContr.CRM_Status__c='New';
        rebContr.Name='10';
        rebContr.Sales_Org__c=sorg.Id;
        insert rebContr;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Get_Goals_URL__c='www.www.com',Rebate_Get_History_URL__c ='www.www.com');  
        Boolean result;
        GetApprovalHistoryRequestWrapper reqApp = new GetApprovalHistoryRequestWrapper();
        reqApp.companyCode='5190';
        reqApp.contractNumber='10';
        result=RebateServiceHelper.getApprovalHistory(reqApp);
        reqApp.contractNumber='20';
        result=RebateServiceHelper.getApprovalHistory(reqApp);
        }
    }
    
}