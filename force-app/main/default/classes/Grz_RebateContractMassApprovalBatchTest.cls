/**************************************************************************************************
* Name               : Grz_RebateContractMassApprovalBatch                                                      
* Description        : Batch class
* Test Class         : Grz_RebateContractMassApprovalBatchTest
* Created By         : Swaranjeet(Grazitti) APPS-4793- Brazil (Rebate mass approval)                                                                      
**************************************************************************************************/
@isTest
public class Grz_RebateContractMassApprovalBatchTest {
   
    
     static testMethod void CallgetGoals3(){
        
List<Rebate_Contract__c> rebateList=new List<Rebate_Contract__c>();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        UPL_Settings__c us= new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Send_Goals_URL__c='www.www.com');  
        insert us;
        User u=[Select id from User where isActive=true and profile.name='System Administrator' and email!=null limit 1];
      
         Rebate_Contract__c rebContr1 = new Rebate_Contract__c();
        rebContr1.Combination_Key__c='519010';
        rebContr1.CRM_Status__c='Rejected';
        rebContr1.Name='10';
        rebContr1.Sales_Org__c=sorg.Id;
        rebContr1.Last_Sent_Appoval_Step__c=1;
         rebContr1.Last_Approval_Step__c=4;
        rebContr1.Marketing_Director__c=u.id;
        rebContr1.Regional_Manager__c=u.id;
        rebContr1.SBU_Head__c=u.id;
        rebContr1.Territory_Manager__c=u.id;
        rebContr1.Zonal_Manager__c=u.id;
      // rebContr1.Integration_Approval_Step__c='2';
        insert rebContr1;
         Rebate_Goal_SKU__c RGSKU = new Rebate_Goal_SKU__c();
        
      // List<Rebate_Goal_SKU__c> RGSKU= [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,
       //Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c, 
       // Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :rebContr1.id limit 1];
        // RGSKU.Name='RGS-0000500459';
         //RGSKU.SKU_Code__c='000000000006031990';
        // RGSKU.Product_Category__c=
         RGSKU.Volume_LY__c=90;
         RGSKU.Price_LY__c=80;
         RGSKU.Value_LY__c=70;
         RGSKU.Volume__c=60;
         RGSKU.Price__c=50;
         RGSKU.Value__c=50;
         //RGSKU.Actual_Value__c
        // RGSKU.Contract__r.name=rebContr1.Name;
         RGSKU.SKU__c='a1C0K000008GzSrUAK';
        // RGSKU.SKU__r.SKU_Code__c
        // RGSKU.SKU__r.Name
       //  RGSKU.Actual_Volume__c
         //RGSKU.Brand_Name__c='FOLTRON PLUS';
         RGSKU.Contract__c = rebContr1.Id;
         insert RGSKU;
         
         
          Rebate_Contract__c rebContr11 = new Rebate_Contract__c();
        rebContr11.Combination_Key__c='519011';
        rebContr11.CRM_Status__c='Rejected';
        rebContr11.Name='10';
        rebContr11.Sales_Org__c=sorg.Id;
        rebContr11.Last_Sent_Appoval_Step__c=1;
         rebContr11.Last_Approval_Step__c=1;
        rebContr11.Marketing_Director__c=u.id;
        rebContr11.Regional_Manager__c=u.id;
        rebContr11.SBU_Head__c=u.id;
        rebContr11.Territory_Manager__c=u.id;
        rebContr11.Zonal_Manager__c=u.id;
         rebContr11.Last_Goals_Sent_Status__c = 'Success';
      // rebContr1.Integration_Approval_Step__c='2';
        insert rebContr11;
         Rebate_Contract__c rebContr12 = new Rebate_Contract__c();
         rebContr12.Id = rebContr11.Id;
       rebContr12.Last_Goals_Sent_Status__c = 'Failure';
         update rebContr12;
          Rebate_Goal_SKU__c RGSKU1 = new Rebate_Goal_SKU__c();
     
         RGSKU1.Volume_LY__c=90;
         RGSKU1.Price_LY__c=80;
         RGSKU1.Value_LY__c=70;
         RGSKU1.Volume__c=60;
         RGSKU1.Price__c=50;
         RGSKU1.Value__c=50;
       
         RGSKU1.SKU__c='a1C0K000006lHsdUAE';
        
         RGSKU1.Contract__c = rebContr11.Id;
         insert RGSKU1;
         list<Rebate_Goal_SKU__c> RGlist = new list<Rebate_Goal_SKU__c>{RGSKU,RGSKU1};
           Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
       req1.setObjectId(rebContr1.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id);
        

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Rebate_Approval_Processv');
        req1.setSkipEntryCriteria(true);

       
        Approval.ProcessResult result = Approval.process(req1);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('mRequest.');
        req2.setAction('Removed');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req2.setWorkitemId(result.newWorkItemIds.get(0));
		

        
      
Approval.unlock(rebContr1.id);    
            
         SendGoalRequestWrapper send= new SendGoalRequestWrapper();
        send.actionCode= '1';
        send.I_NETOUT='0.00';
        send.userRole='5';   
        send.companyCode='5190';
        send.contractNumber='10';
        send.approverEmail='rafael.chiavenato@upl-ltd.com.invalid';
        send.I_ENVIAR='3';
        send.comments='TEST';
      
        list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
        SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
         for (Rebate_Goal_SKU__c RG: RGlist){
             
              lst.volume=string.valueOf(RG.Volume__c);
             lst.unitPrice=string.valueOf(RG.Price__c);
             lstToSend.add(lst);
         }
      
       /*lst.skuCode='000000000006250320';
             lst.volume='10';
             lst.unitPrice='10';
             lstToSend.add(lst); */
        SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
        gItem.item= lstToSend;
        send.goals=gItem;
       
      
        Test.startTest();
    /* Grz_RebateContractMassApprovalBatch.setvar(rebContr1.id);
                Grz_RebateContractMassApprovalBatch.setvar2(rebContr1.id);
          Grz_RebateContractMassApprovalBatch.setvar3(rebContr1.id);
                Grz_RebateContractMassApprovalBatch.setvar4(rebContr1.id);*/
        Grz_RebateContractMassApprovalBatch obj = new Grz_RebateContractMassApprovalBatch(new list<ID> {rebContr1.id,rebContr11.id});
        Grz_RebateContractMassApprovalBatch.SendGoals(send);
        DataBase.executeBatch(obj); 
        Test.stopTest();
  }
   
       static testMethod void CallgetGoals4(){
        
List<Rebate_Contract__c> rebateList=new List<Rebate_Contract__c>();
        Sales_Org__c sorg =TestDataFactory.CreateSalesOrg();
        UPL_Settings__c us= new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test',Rebate_Send_Goals_URL__c='www.www.com');  
        insert us;
        User u=[Select id from User where isActive=true and profile.name='System Administrator' and email!=null limit 1];
      
         Rebate_Contract__c rebContr1 = new Rebate_Contract__c();
        rebContr1.Combination_Key__c='519010';
        rebContr1.CRM_Status__c='Approved';
        rebContr1.Name='10';
        rebContr1.Sales_Org__c=sorg.Id;
        rebContr1.Last_Sent_Appoval_Step__c=1;
         rebContr1.Last_Approval_Step__c=1;
        rebContr1.Marketing_Director__c=u.id;
        rebContr1.Regional_Manager__c=u.id;
        rebContr1.SBU_Head__c=u.id;
        rebContr1.Territory_Manager__c=u.id;
        rebContr1.Zonal_Manager__c=u.id;
           rebContr1.Last_Goals_Sent_Status__c='Success';
          
      // rebContr1.Integration_Approval_Step__c='2';
        insert rebContr1;
          
         
           Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
       req1.setObjectId(rebContr1.id);

        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id);
        

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Rebate_Approval_Processv');
        req1.setSkipEntryCriteria(true);

       
        Approval.ProcessResult result = Approval.process(req1);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('mRequest.');
        req2.setAction('Removed');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req2.setWorkitemId(result.newWorkItemIds.get(0));

       
        Approval.ProcessResult result2 =  Approval.process(req2);
    
		Approval.unlock(rebContr1.id);   
            
         SendGoalRequestWrapper send= new SendGoalRequestWrapper();
        send.actionCode= '1';
        send.I_NETOUT='0.00';
        send.userRole='12';   
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
        //send.goals=gItem;
      send.goals=null;
       
        Test.startTest();
      
        Grz_RebateContractMassApprovalBatch obj = new Grz_RebateContractMassApprovalBatch(new list<ID> {rebContr1.id});
            DataBase.executeBatch(obj);
        
         
        Grz_RebateContractMassApprovalBatch.SendGoals(send);
     
        Test.stopTest();
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
        rebContr.Last_Sent_Appoval_Step__c=1;
        rebContr.Last_Approval_Step__c=4;
        insert rebContr;
        
        SendGoalRequestWrapper send= new SendGoalRequestWrapper();
        send.actionCode= '2';
        send.I_NETOUT='0.00';
        send.userRole='15';   
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
        temp=Grz_RebateContractMassApprovalBatch.SendGoals(send);
       system.debug('temp is'+ temp);
        delete us;
        insert new UPL_Settings__c(Visibility_Date__c = 10,SalesOrg__c='5191',PaddingSAPCode__c=10,PaddingSKU__c=18,BR_Sales_Org__c='5191',Stock_in_Channel_RFC__c='www.www.com',HCI_User_Name__c='test',HCI_Password__c='test');  
        temp=Grz_RebateContractMassApprovalBatch.SendGoals(send);
        system.debug('temp is'+ temp);
   }
    
    
   
}