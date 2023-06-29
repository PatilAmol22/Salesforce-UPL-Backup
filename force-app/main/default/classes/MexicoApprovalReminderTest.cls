@isTest 
public class MexicoApprovalReminderTest 
{
    public static testMethod void testMethodApproval() 
    {                  
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name  = 'Territory Manager for Mexico' LIMIT 1]; 
        User userTerMan = new User(
            Alias = 'WESLLEY',                                                           
            Email = 'shama@skinternational.com',                                          
            ProfileId = p.Id,                                                             
            Username = '20005489@uniphos3.com.upltest',                                    
            IsActive = true,                                                              
            LastName='BARBOSA DE CAMARGO',
            CommunityNickname = 'XWESLLEY ',                                              
            Title = 'RTV JR',                                                          
            TimeZoneSidKey = 'America/Sao_Paulo',     
            LocaleSidKey = 'en_IN',                                           
            LanguageLocaleKey = 'pt_BR',                                               
            ForecastEnabled = false,                                                      
            EmailEncodingKey = 'ISO-8859-1',                                            
            EnableDepot__c = false,                                                      
            Show_List_Value__c = false,                                                  
            Show_Credit_Limit__c = false,                                                
            Show_Inventory__c = false,                                                  
            Show_Pricing__c = false,                                                     
            Show_Inventory_Column__c = false,                                            
            Show_InTransit__c = false,                                                    
            Show_InTransit_Values__c = false                                           
        );
        
        System.runAs(userTerMan){
            //-------------------------------------------------------------
            Sales_Org__c sorg = new Sales_Org__c();
            sorg.Name='Mexico';
            sorg.Sales_Org_Code__c='5100';
            insert sorg;
            //-------------------------------------------------------------
            Division__c div = new Division__c();
            div.Name='Agro Formulation';
            div.Description__c='Mexico';
            div.Division_Code__c = '10';
            insert div;
            Distribution_Channel__c dChannel= new Distribution_Channel__c();
            dChannel.Name='New UPL - End users';
            dChannel.Distribution_Channel_Code__c = '67';
            insert dChannel;
            //--------------------------------------------------------------
            Account acc = new Account();
            acc.Name='7273 PRODUCTORA DE FERTILIZANTES';
            acc.Email__c = 'harsh@gmail.com';
            //acc.Last_Name__c=' PASSINATO';
            acc.SAP_Code__c='2028843';
            acc.RecordTypeId=devRecordTypeId;
            acc.Mobile__c='9967341759';
            acc.Phone='01234567891';
            acc.Sales_Org__c=sorg.Id;
            acc.Division__c=Div.Id;
            acc.Distribution_Channel__c=dChannel.Id;
            acc.BillingCity='MINEIROS';
            acc.SAP_Code__c='2028843';
            acc.Depot_Code__c='MX51';
            acc.Tax_Number_3__c='114415455';
            acc.Customer_Region__c='AC';
            acc.Customer_Group__c='001';
            acc.Program_Margin_Discount__c=0.00;
            acc.Active__c=true;
            insert acc;
            //----------------------------------------------------------------------
            Sales_Order__c sobj = new Sales_Order__c(
                OwnerId = userTerMan.Id, 
                SFDC_Order_Number__c = '8360',                    
                SAP_Order_Number__c = '7009090604',                 
                Order_Cancel__c = false,     
                Sales_Org_lk__c = sorg.Id,                             
                Order_Status__c = 'Not yet processed',                                                 
                RequestforCancellationCheck__c = false,  
                BudgetApprovalCheck__c = false,
                Order_Raise_By__c='Territory Manager',
                Sent_for_Manager_Approval_Mexico__c= TRUE ,
                Manager__c = userTerMan.id,
                Flag_Status__c = 'dislike\n',                       
                Key_Account__c = false,                             
                Sold_to_Party__c = acc.Id,                        
                Valid_FROM__c = system.today(), 
                Valid_To__c = system.today()+350                 
            );
            insert sobj;
            
            Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
            app.setObjectId(sobj.id);
            app.setProcessDefinitionNameOrId('New_Mexico_SO_Approval_Process_V1_7');  
            app.setSkipEntryCriteria(true);
            Approval.ProcessResult result = Approval.process(app);
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            /*Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approving Request');
            req.setAction('Approve');
            //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setWorkitemId(newWorkItemIds.get(0));   
            Approval.ProcessResult result1 = Approval.process(req);*/
            ProcessInstance processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :sobj.id];
            ProcessInstanceWorkitem processitem = [SELECT ID,ElapsedTimeInDays,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status,ProcessInstance.TargetObject.Type,ProcessInstance.ProcessDefinition.Name FROM ProcessInstanceWorkitem WHERE ProcessInstanceId= :processInstances.Id ];
        }
        //----------------------------------------------------------------------------------------------
        Test.startTest();
        MexicoApprovalReminder obj = new MexicoApprovalReminder();
        DataBase.executeBatch(obj);             
        Test.stopTest();
    }
}