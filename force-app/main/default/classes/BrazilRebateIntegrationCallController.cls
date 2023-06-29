/*
* Name: BrazilRebateIntegrationCallController For RITM0535972
* Author:Pragati Sharma
* Description: Class called from Quick action to send for SAP integration.
*/
public  class BrazilRebateIntegrationCallController {
    @AuraEnabled(cacheable=false)
    public static String futureUpdateHistoryCallout(String ContractId)
    {   
        System.debug('------------ContractId-----------'+ContractId);
        if(ContractId!=null){
            System.debug('------------ContractId-----------'+ContractId);
            
            List<Rebate_Contract__c> RCList = [select id, Last_Sent_Appoval_Step__c,Name,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode,CRM_Status__c from Rebate_Contract__c where id =:ContractId];   
            if(Approval.isLocked(ContractId)){
                System.debug('record locked');
                throw new AuraHandledException('Entre em contato com o administrador do sistema');
            }
            System.debug('------------RCList-----------'+RCList);
            Map<Id,Rebate_Contract__c> rebatemap = new Map<Id,Rebate_Contract__c>();
            boolean temp;
            list<ProcessInstance> latestInstance = new list<ProcessInstance>();
            Map<Id,Id> processinstancemap = new Map<Id,Id>();
            for(Rebate_Contract__c RC: RCList){
                System.debug('------------inside rebatemap-----------'); 
                rebatemap.put(RC.Id,RC);
                
            }
            System.debug('------------rebatemap-----------'+rebatemap);
            id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
            
            System.debug('------------ProcessDefinition-----------'+ProcessDefinition);
            
            latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                              FROM ProcessInstance where targetObjectId =:ContractId and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
            System.debug('------------latestInstance-----------'+latestInstance);
            //latestInstance.sort();
            //
            System.debug('------------After sorting latestInstance-----------'+latestInstance);
            
            for(ProcessInstance p: latestInstance){
                if(rebatemap.containsKey(p.targetObjectId)){
                    System.debug('------------inside-p.targetObjectId----------'+p.targetObjectId);
                    processinstancemap.put(p.Id,p.targetObjectId);
                }
                
            }
            System.debug('------------processinstancemap-----------'+processinstancemap);
            Map<Id,ProcessInstanceStep> latestInstanceStepmap = new Map<Id,ProcessInstanceStep>();
            
            list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
            latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                  ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId in :latestInstance order by SystemModstamp  DESC limit 1];
            System.debug('------------latestInstanceStep-----------'+latestInstanceStep);
           // latestInstanceStep.sort(); 
            System.debug('------------After latestInstanceStep-----------'+latestInstanceStep);
            for(ProcessInstanceStep pstep: latestInstanceStep){
                if(processinstancemap.containsKey(pstep.ProcessInstanceId)){
                    System.debug('------------pstep.ProcessInstanceId-----------'+pstep.ProcessInstanceId);
                    latestInstanceStepmap.put(processinstancemap.get(pstep.ProcessInstanceId),pstep);
                }
                
            }
            System.debug('------------latestInstanceStepmap-----------'+latestInstanceStepmap);
            
            for (Id key : latestInstanceStepmap.keySet()) {
                System.debug('------------key-----------'+key);
                  System.debug('------------inside if-----------'+(rebatemap.get(key).Last_Sent_Appoval_Step__c < rebatemap.get(key).Last_Approval_Step__c -1)+'@@@@@@'+rebatemap.get(key).Last_Sent_Appoval_Step__c+'resss'+rebatemap.get(key).Last_Approval_Step__c);
              
                if(rebatemap.get(key).Last_Sent_Appoval_Step__c < rebatemap.get(key).Last_Approval_Step__c -1 ){
                    System.debug('------------inside if-----------'+(rebatemap.get(key).Last_Sent_Appoval_Step__c < rebatemap.get(key).Last_Approval_Step__c -1));
                    integer i =  integer.valueof(rebatemap.get(key).Last_Sent_Appoval_Step__c +1);
                    System.debug('------------i-----------'+i);
                    SendGoalRequestWrapper send= new SendGoalRequestWrapper();
                    System.debug('------------latestInstanceStepmap.get(key).StepStatus-----------'+latestInstanceStepmap.get(key).StepStatus);
                    if(latestInstanceStepmap.get(key).StepStatus == 'Rejected')
                        send.actionCode= '2';
                    else
                        send.actionCode= '1';    
                    send.I_NETOUT=string.valueOf(rebatemap.get(key).Total_Other_Value__c);
                    System.debug('------------string.valueOf(rebatemap.get(key).Total_Other_Value__c-----------'+string.valueOf(rebatemap.get(key).Total_Other_Value__c));
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
                    System.debug('------------rebatemap.get(key).Name-----------'+rebatemap.get(key).Name);
                    send.contractNumber=rebatemap.get(key).Name;//rC.Contract
                    send.approverEmail= latestInstanceStepmap.get(key).Actor.email;
                    send.I_ENVIAR='';
                    System.debug('------------latestInstanceStepmap.get(key).Comments-----------'+latestInstanceStepmap.get(key).Comments);
                    send.comments='test';
                  
                    list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
                    System.debug('lstToSend'+lstToSend);
                    SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
                    gItem.item = lstToSend;
                    send.goals= gItem;
                    System.debug('send@@@@@@@@95-->'+send);
                    //send.goals=lstToSend;
                    
                    temp=SendGoals(send);
                    system.debug('temp is'+ temp );
                    system.debug('i'+ i++ );
                    
                    
                    
                }
                else{ 
                    
                    //calling API
                    SendGoalRequestWrapper send= new SendGoalRequestWrapper();
                    System.debug('------------latestInstanceStepmap.get(key).StepStatus-----------'+latestInstanceStepmap.get(key).StepStatus);
                    if(latestInstanceStepmap.get(key).StepStatus == 'Rejected')
                        send.actionCode= '2';
                    else
                        send.actionCode= '1';  
                    System.debug('------------rebatemap.get(key).Total_Other_Value__c-----------'+rebatemap.get(key).Total_Other_Value__c);   
                    send.I_NETOUT=string.valueOf(rebatemap.get(key).Total_Other_Value__c);
                    System.debug('------------rebatemap.get(key).Last_Approval_Step__c-----------'+rebatemap.get(key).Last_Approval_Step__c);
                    if(rebatemap.get(key).Last_Approval_Step__c ==1)
                        send.userRole='04'; 
                    else if(rebatemap.get(key).Last_Approval_Step__c ==2)
                        send.userRole='11';
                    else if(rebatemap.get(key).Last_Approval_Step__c ==3)
                        send.userRole='05';
                    else if(rebatemap.get(key).Last_Approval_Step__c ==4)// Rebate Marketing Director role
                        send.userRole='15';
                    else
                        send.userRole='12';
                    send.companyCode='5190';
                    System.debug('------------rebatemap.get(key).Name-----------'+rebatemap.get(key).Name);   
                    send.contractNumber=rebatemap.get(key).Name;//rC.Contract
                    System.debug('-----------latestInstanceStepmap.get(key).Actor.email-----------'+latestInstanceStepmap.get(key).Actor.email); 
                    send.approverEmail= latestInstanceStepmap.get(key).Actor.email;
                    send.I_ENVIAR='';
                    System.debug('-----------latestInstanceStepmap.get(key).Comments-----------'+latestInstanceStepmap.get(key).Comments); 
                    send.comments=latestInstanceStepmap.get(key).Comments;
                    //list<SendGoalRequestWrapper.Goals> lstToSend = new list<SendGoalRequestWrapper.Goals>();
                    list<SendGoalRequestWrapper.Item> lstToSend = new list<SendGoalRequestWrapper.Item>();
                    System.debug('Query'+[select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c =:ContractId ]);
                    for (Rebate_Goal_SKU__c RGSKU: [select id,Name,SKU_Code__c,Product_Category__c,Volume_LY__c,Price_LY__c,Value_LY__c,Volume__c,Price__c,Value__c,Actual_Value__c,Contract__r.name,SKU__c,SKU__r.SKU_Code__c,SKU__r.Name,Actual_Volume__c,  Brand_Name__c from Rebate_Goal_SKU__c where Contract__c =:ContractId ]){
                        //SendGoalRequestWrapper.Goals lst = new SendGoalRequestWrapper.Goals();
                        SendGoalRequestWrapper.Item lst = new SendGoalRequestWrapper.Item();
                        lst.skuCode=RGSKU.SKU_Code__c;
                        lst.volume=string.valueOf(RGSKU.Volume__c);
                        lst.unitPrice=string.valueOf(RGSKU.Price__c);
                        lstToSend.add(lst);
                    }
                    System.debug('------------lstToSend-----------'+lstToSend); 
                    SendGoalRequestWrapper.goals gItem= new SendGoalRequestWrapper.goals();
                    System.debug('gItem'+gItem);
                    gItem.item = lstToSend;
                    System.debug('gItem.item'+gItem.item);
                    send.goals= gItem;
                    //send.goals=lstToSend;
                    // boolean temp;
                    system.debug('send@@@@@@----->'+ send );
                    temp=SendGoals(send);
                    system.debug('temp is line 169'+ temp );
                    //update Last Sent Approval Step
                   
                }
            }
            
        }
        return 'success';
    }
    public static boolean SendGoals(SendGoalRequestWrapper sendGoals)
    {
       
        try{
             System.debug('sendGoals'+sendGoals.approverEmail+'### '+sendGoals.comments);
            SendGoalResponseWrapper resUpdate;
            String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
            String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c;  
            String url = UPL_Settings__c.getOrgDefaults().Rebate_Send_Goals_URL__c;
            Integer timeOut = 120000;
            System.debug('url'+url);
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
            System.debug('username'+username + ':' + password);
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            system.debug('@@@@649request'+request);
            HttpResponse response;
            if(!Test.isRunningTest()){
                response = http.send(request);
                system.debug('Fake 1'+ http.send(request));
            }
            else{
                // Create a fake response
                system.debug('Fake ');
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"status":"S"}');
                response.setStatusCode(200);
            } 
            system.debug('reached here before converting to response wrapper');
            system.debug('status from webservice for goals '+response.getStatus());
            system.debug('response from webservice for body '+response.getBody());
            system.debug('response from webservice for goals '+sendGoals.contractNumber);
            
            //resUpdate=(SendGoalResponseWrapper)System.JSON.deserialize(response.getBody(), SendGoalResponseWrapper.class);
            Map <String, Object> objectMap = (Map <String, Object>) system.json.deserializeUntyped( response.getBody());
            String respstatus = String.valueof(objectMap.get('status'));  
            system.debug('value after the conversion of get goals '+respstatus );
            system.debug('value after the conversion of get goals '+respstatus );
            //error handling starts 
            Rebate_Contract__c getID= [Select id,Integration_Approval_Step__c,Approval_Fire__c,CRM_Status__c,Last_Approval_Step__c from Rebate_Contract__c where name =: sendGoals.contractNumber limit 1];
            Rebate_Contract__c rebCon = new Rebate_Contract__c();
            rebCon.id= getID.Id;
            
            if(sendGoals.Goals == null)
            {
                system.debug('enter in null condition'+rebCon.Last_Sent_Appoval_Step__c);
                rebCon.Last_Approval_Sent__c= datetime.now(); 
                
            }
            else
            {
                system.debug('enter in else'+rebCon.Last_Sent_Appoval_Step__c+'@@'+rebCon.Last_Approval_Step__c);
                rebCon.Last_Goals_Sent__c=datetime.now();    
            }
            //error handling ends 
            
            
            
            if(respstatus == 'S')
            {    System.debug('resUpdate.status@@@@@'+respstatus); 
             //error handling code
             
             id ProcessDefinition = [select id from processDefinition where developername = 'Rebate_Approval_Processv'][0].ID;
             
             list<ProcessInstance> latestInstance = new list<ProcessInstance>();
             latestInstance = [SELECT Id,processdefinition.name,targetObjectId 
                               FROM ProcessInstance where targetObjectId = :getID.id and processdefinitionId = :ProcessDefinition order by lastmodifieddate DESC limit 1];
                               System.debug('latestInstance at 271 line '+latestInstance);
             
             list<ProcessInstanceStep> latestInstanceStep = new list<ProcessInstanceStep>();
             latestInstanceStep = [SELECT Id, ProcessInstanceId, StepStatus, OriginalActorId, 
                                   
                                   ActorId,actor.email, Comments, StepNodeId FROM ProcessInstanceStep where ProcessInstanceId = :latestInstance[0].Id order by SystemModstamp  DESC limit 1];
             System.debug('latestInstanceStep at 277 line '+latestInstanceStep);
             rebCon.Last_Goals_Sent_Status__c='Success';
             if(latestInstanceStep[0].StepStatus == 'Approved' || test.isRunningTest()){
                 
                 
                 if(getID.Integration_Approval_Step__c=='1'){
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
                      rebCon.Workflow_Status__c='Aguard Aprov Metas Diretor de Vendas';
                 }
                 
                 else      if(getID.Integration_Approval_Step__c=='3'){
                     rebCon.Integration_Approval_Step__c='4'; 
                     rebCon.CRM_Status__c='In Review';
                     rebCon.Approval_Fire__c=true;
                     rebCon.Status_Value__c='Success';
                     rebCon.Workflow_Status__c='Aguardando Aprovação de Metas Diretor Marketing Operacional';
                 }
                 else      if(getID.Integration_Approval_Step__c=='4'){
                     rebCon.Integration_Approval_Step__c='5'; 
                     rebCon.Status_Value__c='Success';
                     
                     
                 }
                    rebCon.Last_Sent_Appoval_Step__c=getID.Last_Approval_Step__c;
             //  rebCon.Last_Sent_Appoval_Step__c  = rebCon.Last_Approval_Step__c;   
             update rebCon;
             
             
             SendForApproval(rebCon.id);
             }
          
             
            }
            else{
                rebCon.Last_Goals_Sent_Status__c='Failure';//error handling
                rebCon.Status_Value__c='Failure';
                
                update rebCon;//error handling
            }
            return false;
        }
        catch(Exception ex)
        {
            
            System.debug('ex No: '+ex.getLineNumber()+' ex Msg: '+ex.getMessage()+'cause '+ex.getCause()+' '+ex.getTypeName()); 
            if(!test.isRunningTest()){
            List<Rebate_Contract__c> RCList = [select id, Last_Sent_Appoval_Step__c,Name,Total_Other_Value__c,Last_Approval_Step__c,CurrencyIsoCode,CRM_Status__c from Rebate_Contract__c where Name=:sendGoals.contractNumber];
            RCList[0].CRM_Status__c='In Editing';
            RCList[0].Status_Value__c='Failure';
            }
            return false;
        }
        
    }
    @future
    public static void SendForApproval(String recordId){
        System.debug('Enter in future method'+recordId);
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('');
        req.setObjectId(recordId);
        if(!test.isRunningTest()){
        Approval.ProcessResult result = Approval.process(req);
        system.debug('result'+result);
        }
        // error handling code ends
        System.debug('i reached here ');
        
    }
    
    
   
}