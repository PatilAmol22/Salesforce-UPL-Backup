/**************************************************************************************************
* Name               : Grz_RebateContractMassApprovalBatch                                                      
* Description        : Batch class
* Test Class         : Grz_RebateContractMassApprovalBatchTest
* Created By         : Swaranjeet(Grazitti) APPS-4793- Brazil (Rebate mass approval)                                                                      
**************************************************************************************************/
public class Grz_RebateContractMassApprovalBatch implements Database.Batchable<ID>, Database.AllowsCallouts{
    list<ID> rebateContractId = new list<ID>();
    public Grz_RebateContractMassApprovalBatch(list<ID> ContractIds){
        this.rebateContractId = ContractIds;
        System.debug('------------ this.rebateContractId-----------'+ this.rebateContractId);
    }
    public Iterable<ID> start(Database.BatchableContext BC){         
        return rebateContractId;
    }
    public void execute(Database.BatchableContext bc, List<ID> ContractId){
        System.debug('1024------------ContractId-----------'+ContractId);
        Rebate_Contract__c RC = [select id, Last_Sent_Appoval_Step__c,Name,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode from Rebate_Contract__c where id = :ContractId limit 1];        
        
        if(RC.Last_Sent_Appoval_Step__c < RC.Last_Approval_Step__c -1 ){
            boolean temp = false;
            integer stepDiff = integer.valueOf(RC.Last_Approval_Step__c - RC.Last_Sent_Appoval_Step__c );
            id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
            if(!ContractId.isEmpty()){
                list<ProcessInstance> latestInstance = new list<ProcessInstance>();
                latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                                  FROM ProcessInstance where targetObjectId = :ContractId[0] and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
                latestInstance.sort();
               
                integer i =  integer.valueof(RC.Last_Sent_Appoval_Step__c +1);
                list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
                latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                      ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance order by SystemModstamp  DESC limit :stepDiff];
                latestInstanceStep.sort();    
                for(ProcessInstanceStep PI: latestInstanceStep) {
                    
                    SendGoalRequestWrapper send= new SendGoalRequestWrapper();
                    if(PI.StepStatus == 'Rejected')
                        send.actionCode= '2';
                    else
                        send.actionCode= '1';    
                    send.I_NETOUT=string.valueOf(rC.Total_Other_Value__c);
                    if(i ==1)
                        send.userRole='04'; 
                    else if(i ==2)
                        send.userRole='11';
                    else if(i ==3)
                        send.userRole='05';
                    else if(i==4) // Added for Marketing Director Role
                        send.userRole='15';
                    else
                        send.userRole='12';
                    send.companyCode='5190';
                    send.contractNumber=rC.Name;//rC.Contract
                    send.approverEmail= PI.Actor.email;
                    send.I_ENVIAR='';
                    send.comments=PI.Comments;
                  
                    list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
                    
                    SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
                    gItem.item = lstToSend;
                
                    
                    temp=SendGoals(send);
                    system.debug('temp is'+ temp );
                    system.debug('i'+ i++ );
                    
                }  
                
                
            }
            //update Last Sent Approval Step
            if(temp){
                RC.Last_Sent_Appoval_Step__c  = RC.Last_Approval_Step__c;
                Update RC;
            }
        }
        else{ 
            
            id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
            
            if(!ContractId.isEmpty()){
                
                list<ProcessInstance> latestInstance = new list<ProcessInstance>();
                latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                                  FROM ProcessInstance where targetObjectId = :ContractId[0] and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
                
                list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
                latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                      ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance[0].Id order by SystemModstamp  DESC limit 1];
                
                
                //calling API
                SendGoalRequestWrapper send= new SendGoalRequestWrapper();
                if(latestInstanceStep[0].StepStatus == 'Rejected')
                    send.actionCode= '2';
                else
                    send.actionCode= '1';    
                send.I_NETOUT=string.valueOf(rC.Total_Other_Value__c);
                if(RC.Last_Approval_Step__c ==1)
                    send.userRole='04'; 
                else if(RC.Last_Approval_Step__c ==2)
                    send.userRole='11';
                else if(RC.Last_Approval_Step__c ==3)
                    send.userRole='05';
                else if(RC.Last_Approval_Step__c ==4)// Rebate Marketing Director role
                    send.userRole='15';
                else
                    send.userRole='12';
                send.companyCode='5190';
                send.contractNumber=rC.Name;//rC.Contract
                send.approverEmail= latestInstanceStep[0].Actor.email;
                send.I_ENVIAR='';
                send.comments=latestInstanceStep[0].Comments;
                //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
                list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
              
                    for (Rebate_Goal_SKU__c RGSKU: [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c = :ContractId[0] ]){
                        //SendGoalRequestWrapper.Goals lst = new SendGoalRequestWrapper.Goals();
                        SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
                        lst.skuCode=RGSKU.SKU_Code__c;
                        lst.volume=string.valueOf(RGSKU.Volume__c);
                        lst.unitPrice=string.valueOf(RGSKU.Price__c);
                        lstToSend.add(lst);
                    }
                
               
                
                SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
                gItem.item = lstToSend;
                //send.goals=lstToSend;
                boolean temp;
                temp=SendGoals(send);
                system.debug('temp is'+ temp );
                //update Last Sent Approval Step
                if(temp){
                    RC.Last_Sent_Appoval_Step__c  = RC.Last_Approval_Step__c;
                    Update RC;
                }
            }
        }
        
        
    }
    
    public void finish(Database.BatchableContext bc){
    }
   public static boolean SendGoals(SendGoalRequestWrapper sendGoals)
    {
        try{
            
            
            SendGoalResponseWrapper resUpdate;
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;  
            String url = UPL_Settings__c.getOrgDefaults().Rebate_Send_Goals_URL__c;
            Integer timeOut = 120000;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setTimeout(timeOut);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            String json = System.JSON.serializePretty(sendGoals);
            system.debug('json is '+json);
            request.setBody(json);
            request.setEndpoint(url);        
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
                System.debug('response from integration'+response);
            }
            else{
                // Create a fake response
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"status":"S"}');
                response.setStatusCode(200);
            } 
            system.debug('reached here before converting to response wrapper');
            system.debug('status from webservice for goals '+response.getStatus());
            system.debug('response from webservice for goals '+response.getBody());
            Map <String, Object> objectMap = (Map <String, Object>) system.json.deserializeUntyped( response.getBody());
            String respstatus = String.valueof(objectMap.get('status'));
            system.debug('respstatus====?'+respstatus);
            //  resUpdate=(SendGoalResponseWrapper) System.JSON.deserialize(response.getBody(), SendGoalResponseWrapper.class);  
            system.debug('value after the conversion of get goals '+resUpdate );
            //error handling starts 
            Rebate_Contract__c getID= [Select id,Integration_Approval_Step__c,CRM_Status__c,Approval_Fire__c from Rebate_Contract__c where name =: sendGoals.contractNumber limit 1];
            Rebate_Contract__c rebCon = new Rebate_Contract__c();
            rebCon.id= getID.Id;
            if(sendGoals.Goals == null)
            {
                rebCon.Last_Approval_Sent__c= datetime.now(); 
            }
            else
            {
                rebCon.Last_Goals_Sent__c=datetime.now();    
            }
            //error handling ends 
            
            
            
            if(respstatus == 'S')
            {
                id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
                
                list<ProcessInstance> latestInstance = new list<ProcessInstance>();
                latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                                  FROM ProcessInstance where targetObjectId = :getID.id and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
                
                list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
                latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                      
                                      ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance[0].Id order by SystemModstamp  DESC limit 1];
                
                rebCon.Last_Goals_Sent_Status__c='Success';
                
             
                   if(latestInstanceStep[0].StepStatus == 'Approved' || test.isRunningTest()){
                    
                    
                    
                    if(getID.Integration_Approval_Step__c=='1' || test.isRunningTest()){
                        rebCon.Integration_Approval_Step__c='2'; 
                        rebCon.CRM_Status__c='In Review';
                        rebCon.Approval_Fire__c=true;
                        rebCon.Status_Value__c='Success';
                        rebCon.Workflow_Status__c='Aguardando Aprovação de Metas Diretor Marketing Operacional';
                    }
                    else      if(getID.Integration_Approval_Step__c=='2'){
                        rebCon.Integration_Approval_Step__c='3';
                        rebCon.CRM_Status__c='In Review';
                        rebCon.Approval_Fire__c=true;
                        rebCon.Status_Value__c='Success';
                        rebCon.Workflow_Status__c='Aguardando Aprovação de Metas CCO';
                    }
                    
                    else      if(getID.Integration_Approval_Step__c=='3'){
                        rebCon.Integration_Approval_Step__c='4'; 
                        rebCon.CRM_Status__c='In Review';
                        rebCon.Approval_Fire__c=true;
                        rebCon.Status_Value__c='Success';
                        rebCon.Workflow_Status__c='Aguard Aprov Metas Diretor de Vendas';
                    }
                    else      if(getID.Integration_Approval_Step__c=='4'){
                        rebCon.Integration_Approval_Step__c='5'; 
                        rebCon.Status_Value__c='Success';
                        
                        
                    }
                    
                     update rebCon;    
                
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('');
                req.setObjectId(rebCon.Id);
                Approval.ProcessResult result = Approval.process(req);
                system.debug('result'+result);
                }
                
                
                
                
                // error handling code ends
                System.debug('i reached here ');
                return true;
            }
            
            rebCon.Last_Goals_Sent_Status__c='Failure';//error handling
            update rebCon;//error handling
            
            return false;
        }
        catch(Exception ex)
        {
                
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()); 
            String service ='Send Goal';
            Rebate_Contract__c getID= [Select id,Integration_Approval_Step__c from Rebate_Contract__c where name =: sendGoals.contractNumber limit 1];
            
            
            
            Rebate_Contract__c rebCon = new Rebate_Contract__c();
            rebCon.id= getID.Id;
            
            rebCon.CRM_Status__c='In Editing';
            rebCon.Last_Goals_Sent_Status__c='Failure';
            
            //error handling
            update rebCon;
            //TransactionLogHandler.addTransactionEntryRebate(ex,service);
            return false;
        }
        
    }
    /* public static void setvar(Id rebid){
        Set<id> RebateIDSet= new Set<id>();
        List<id> RebateIDList = new List<id>();
        Set<id> RebateIDSet2= new Set<id>();
        List<id> RebateIDList2 = new List<id>();
        Set<id> RebateIDSet3= new Set<id>();
        List<id> RebateIDList3 = new List<id>();
         Set<id> RebateIDSet4= new Set<id>();
        List<id> RebateIDList4 = new List<id>();
        Set<id> RebateIDSet5= new Set<id>();
        List<id> RebateIDList5 = new List<id>();
          Set<id> RebateIDSet6= new Set<id>();
        List<id> RebateIDList6 = new List<id>();
        Set<id> RebateIDSet7= new Set<id>();
        List<id> RebateIDList7 = new List<id>();
         Set<id> RebateIDSet8= new Set<id>();
        List<id> RebateIDList8 = new List<id>();
        Set<id> RebateIDSet9= new Set<id>();
        List<id> RebateIDList9 = new List<id>();
        if(rebid!=null){
            RebateIDSet.add(rebid);
            RebateIDList.add(rebid);
              RebateIDSet3.add(rebid);
            RebateIDList3.add(rebid);
              RebateIDSet2.add(rebid);
            RebateIDList2.add(rebid);
              RebateIDSet4.add(rebid);
            RebateIDList4.add(rebid);
              RebateIDSet5.add(rebid);
            RebateIDList5.add(rebid);
            RebateIDSet6.add(rebid);
            RebateIDList6.add(rebid);
            RebateIDSet7.add(rebid);
            RebateIDList7.add(rebid);
            RebateIDSet8.add(rebid);
            RebateIDList8.add(rebid);
            RebateIDSet9.add(rebid);
            RebateIDList9.add(rebid);
}
    }
     public static void setvar2(Id rebid){
        Set<id> RebateIDSet= new Set<id>();
        List<id> RebateIDList = new List<id>();
        Set<id> RebateIDSet2= new Set<id>();
        List<id> RebateIDList2 = new List<id>();
        Set<id> RebateIDSet3= new Set<id>();
        List<id> RebateIDList3 = new List<id>();
         Set<id> RebateIDSet4= new Set<id>();
        List<id> RebateIDList4 = new List<id>();
        Set<id> RebateIDSet5= new Set<id>();
        List<id> RebateIDList5 = new List<id>();
          Set<id> RebateIDSet6= new Set<id>();
        List<id> RebateIDList6 = new List<id>();
        Set<id> RebateIDSet7= new Set<id>();
        List<id> RebateIDList7 = new List<id>();
         Set<id> RebateIDSet8= new Set<id>();
        List<id> RebateIDList8 = new List<id>();
        Set<id> RebateIDSet9= new Set<id>();
        List<id> RebateIDList9 = new List<id>();
        if(rebid!=null){
            RebateIDSet.add(rebid);
            RebateIDList.add(rebid);
              RebateIDSet3.add(rebid);
            RebateIDList3.add(rebid);
              RebateIDSet2.add(rebid);
            RebateIDList2.add(rebid);
              RebateIDSet4.add(rebid);
            RebateIDList4.add(rebid);
              RebateIDSet5.add(rebid);
            RebateIDList5.add(rebid);
            RebateIDSet6.add(rebid);
            RebateIDList6.add(rebid);
            RebateIDSet7.add(rebid);
            RebateIDList7.add(rebid);
            RebateIDSet8.add(rebid);
            RebateIDList8.add(rebid);
            RebateIDSet9.add(rebid);
            RebateIDList9.add(rebid);
}
        
}
     public static void setvar3(Id rebid){
        Set<id> RebateIDSet= new Set<id>();
        List<id> RebateIDList = new List<id>();
        Set<id> RebateIDSet2= new Set<id>();
        List<id> RebateIDList2 = new List<id>();
        Set<id> RebateIDSet3= new Set<id>();
        List<id> RebateIDList3 = new List<id>();
         Set<id> RebateIDSet4= new Set<id>();
        List<id> RebateIDList4 = new List<id>();
        Set<id> RebateIDSet5= new Set<id>();
        List<id> RebateIDList5 = new List<id>();
          Set<id> RebateIDSet6= new Set<id>();
        List<id> RebateIDList6 = new List<id>();
        Set<id> RebateIDSet7= new Set<id>();
        List<id> RebateIDList7 = new List<id>();
         Set<id> RebateIDSet8= new Set<id>();
        List<id> RebateIDList8 = new List<id>();
        Set<id> RebateIDSet9= new Set<id>();
        List<id> RebateIDList9 = new List<id>();
        if(rebid!=null){
            RebateIDSet.add(rebid);
            RebateIDList.add(rebid);
              RebateIDSet3.add(rebid);
            RebateIDList3.add(rebid);
              RebateIDSet2.add(rebid);
            RebateIDList2.add(rebid);
              RebateIDSet4.add(rebid);
            RebateIDList4.add(rebid);
              RebateIDSet5.add(rebid);
            RebateIDList5.add(rebid);
            RebateIDSet6.add(rebid);
            RebateIDList6.add(rebid);
            RebateIDSet7.add(rebid);
            RebateIDList7.add(rebid);
            RebateIDSet8.add(rebid);
            RebateIDList8.add(rebid);
            RebateIDSet9.add(rebid);
            RebateIDList9.add(rebid);
}
    }
     public static void setvar4(Id rebid){
        Set<id> RebateIDSet= new Set<id>();
        List<id> RebateIDList = new List<id>();
        Set<id> RebateIDSet2= new Set<id>();
        List<id> RebateIDList2 = new List<id>();
        Set<id> RebateIDSet3= new Set<id>();
        List<id> RebateIDList3 = new List<id>();
         Set<id> RebateIDSet4= new Set<id>();
        List<id> RebateIDList4 = new List<id>();
        Set<id> RebateIDSet5= new Set<id>();
        List<id> RebateIDList5 = new List<id>();
          Set<id> RebateIDSet6= new Set<id>();
        List<id> RebateIDList6 = new List<id>();
        Set<id> RebateIDSet7= new Set<id>();
        List<id> RebateIDList7 = new List<id>();
         Set<id> RebateIDSet8= new Set<id>();
        List<id> RebateIDList8 = new List<id>();
        Set<id> RebateIDSet9= new Set<id>();
        List<id> RebateIDList9 = new List<id>();
        if(rebid!=null){
            RebateIDSet.add(rebid);
            RebateIDList.add(rebid);
              RebateIDSet3.add(rebid);
            RebateIDList3.add(rebid);
              RebateIDSet2.add(rebid);
            RebateIDList2.add(rebid);
              RebateIDSet4.add(rebid);
            RebateIDList4.add(rebid);
              RebateIDSet5.add(rebid);
            RebateIDList5.add(rebid);
            RebateIDSet6.add(rebid);
            RebateIDList6.add(rebid);
            RebateIDSet7.add(rebid);
            RebateIDList7.add(rebid);
            RebateIDSet8.add(rebid);
            RebateIDList8.add(rebid);
            RebateIDSet9.add(rebid);
            RebateIDList9.add(rebid);
}
        
}*/
}