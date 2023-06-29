/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This apex is calles from lightning component - OrderBlockingLC
*
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Swapnil More   <swapnil.more@in.ibm.com>
* @modifiedBy     Swapnil More   <swapnil.more@in.ibm.com>
* @maintainedBy   Swapnil More   <swapnil.more@in.ibm.com>
* @version        1.0
* @created        2020-01-23
* @modified       2020-01-23
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
*                 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
global without sharing class OrderBlocking {
    @Auraenabled
    public static string OrderBlockingMethod(string sapOrderNumber, String comments, string ReasonCode){
        //added one aditional parameter string ReasonCode by Sagar@Wipro - OC-001
        system.debug('comments'+comments);
        Sales_Order__c SO = [select SAP_Order_Number__c, id, ErrorMessage__c,Order_Status__c,Error_Message__c,
                             Order_Blocked__c,SDM_Approval_On_Order_Cancellation__c,
                             Blocked_Cancellation_Message__c,Type_of_Order__c
                             from Sales_Order__c where SAP_Order_Number__c =:sapOrderNumber];
        
        List<Sales_Order__c> LiChildSO = [select id from Sales_Order__c where Sales_Order__c = :SO.Id];
        
         /*if(SO.Type_of_Order__c == 'CONTRATO MÃE' && LiChildSO.size()>0){
            return 'Parent_Order';
        }*/
        //else{
        SalesOrderCancellationRequestWrapper request = new SalesOrderCancellationRequestWrapper();
        request.SAP_Order_Number = sapOrderNumber;
        request.Action = '1';
        request.Rejection_Code = null; // Added by Sagar@Wipro for sending Rejection Code in SAP OC-001
        SalesOrderCancellationResponseWrapper response = OrderBlocking.OrderBlockingAPICall(request);
        
        system.debug('status'+response.Message_Text);
        if(response.Message_Type == 'E'){
            so.Blocked_Cancellation_Message__c = response.Message_Text;
            update so;
            //return 'success';
            return response.Message_Text;
        }
        if(response.Message_Type == 'S'){
            SO.Order_Status__c = 'Blocked';
            SO.SDM_Approval_On_Order_Cancellation__c = 1;
            so.Blocked_Cancellation_Message__c = response.Message_Text;
            if(comments != null){
            so.Cancel_Comment__c = comments;
            }
             so.Cancellation_Reason__c = ReasonCode;
            // SO.Approval_Reason__c = 'Pedido De Venda - Order Cancellation';
            update SO;
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('');
            req.setObjectId(SO.Id);
            req.setProcessDefinitionNameOrId('Order_Cancellation_Approval_Process');
            if(!Test.isRunningTest()){
            Approval.ProcessResult result = Approval.process(req);
            }
            //return 'success';
            return response.Message_Text;
        }
        //}
        return 'success';
    }
    @Auraenabled    
    public static SalesOrderCancellationResponseWrapper OrderBlockingAPICall(SalesOrderCancellationRequestWrapper req){
        SalesOrderCancellationResponseWrapper res;
        String username = UPL_Settings__c.getOrgDefaults().HCI_User_Name__c;
        String password = UPL_Settings__c.getOrgDefaults().HCI_Password__c; 
        String url = UPL_Settings__c.getOrgDefaults().Order_Blocking_URL__c;
        
        Integer timeOut = 120000;
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setTimeout(timeOut);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String json = System.JSON.serializePretty(req);
        
        system.debug('json is '+json);
        request.setBody(json);
        request.setEndpoint(url);        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        //String authorizationHeader='Basic UzAwMDMyNjMzMTM6QWpAMTIzNDU=';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;       
        response = http.send(request);      
        system.debug('reached here before converting to response wrapper');
        system.debug('status from webservice '+response.getStatus());
        system.debug('response from webservice is '+response.getBody());
        res= (SalesOrderCancellationResponseWrapper) System.JSON.deserialize(response.getBody(), SalesOrderCancellationResponseWrapper.class);
        return res;
        
    }
      
    //Method for cancelReason by Harshit&Sirisha@Wipro
   @AuraEnabled
   public static Map<String, String> cancelReason(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order__c.Cancellation_Reason__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
        
    }
    
    @InvocableMethod
    global static void OrderBlockingCancel(list<string> SAPOrderNumber){
        if(System.IsBatch() == false && System.isFuture() == false){ 
             system.debug('Test21');
        futureCallouts(SAPOrderNumber[0]);
        }
        else{
            system.debug('Test12');
        }
        
    }
    /*
    global class ConvertLeadActionRequest {
        @InvocableVariable(required=true)
        global string Type;
        
        @InvocableVariable(required=true)
        global string SAPOrderNumber;
        
        
    }*/
    @future(callout=true)
    public static void futureCallouts(string SAPOrderNumber){
        
        Sales_Order__c SO = [select SAP_Order_Number__c, id,SalesDistrictManager__c,OwnerId ,SFDC_Order_Number__c, ErrorMessage__c,Order_Status__c,Error_Message__c,
                             Order_Blocked__c,SDM_Approval_On_Order_Cancellation__c,Cancel_Comment__c,Cancellation_Reason__c
                             from Sales_Order__c where SAP_Order_Number__c =:sapOrderNumber]; // Query modified by Sagar
        
        List<Sales_Order_Line_Item__c> lstOrderItem = new List<Sales_Order_Line_Item__c>();
        lstOrderItem = [select Id, Sale_Order__c, Quantity__c, Brazil_Product__c, SKU_Name__r.Brand_Name__c, Unbilled_Quatity__c, Quantity_Billed__c, DateofFAT__c, 
                        Sale_Order__r.Order_Status__c from Sales_Order_Line_Item__c where Sale_Order__c =: SO.id];

        Set<string> setBrandName = new Set<string>();
         string recipientId = so.SalesDistrictManager__c;
        string  LoginUserID = UserInfo.getUserId();
        id recipientId1 = so.SalesDistrictManager__c;
        if(SO.SDM_Approval_On_Order_Cancellation__c == 2){
            SalesOrderCancellationRequestWrapper request = new SalesOrderCancellationRequestWrapper();
              request.SAP_Order_Number = SO.SAP_Order_Number__c;
            request.Action = '2';
            request.Rejection_Code = SO.Cancellation_Reason__c; // Added by Sagar@Wipro for sending Rejection Code in SAP OC-001
           // request.Rejection_Code = null;
            
            SalesOrderCancellationResponseWrapper response = OrderBlocking.OrderBlockingAPICall(request);
            //string sTemp = 'E';
            //if(sTemp == 'E'){
            if(response.Message_Type == 'E' || Test.isRunningTest()){
                so.Order_Status__c = 'Blocked'; //Approved
                //so.ErrorMessage__c = response.message;
                so.SDM_Approval_On_Order_Cancellation__c = 2;
                so.Blocked_Cancellation_Message__c = response.Message_Text;
                system.debug('Blocked_Cancellation_Message__c E '+response.Message_Text);
                update so;
                
                // notification
                List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='SDM_Approval_Error_Notification'];
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                currNotification.setTitle('ERRO  ' +so.SFDC_Order_Number__c);
                currNotification.setBody(response.Message_Text);
                currNotification.setSenderId(recipientId);
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification.setTargetId(recipientId);
                
              /*  Messaging.CustomNotification currNotification1 = new Messaging.CustomNotification();
                currNotification1.setTitle('Error  ' +so.SFDC_Order_Number__c);
                currNotification1.setBody('Please Reinitaite your request');
                currNotification1.setSenderId(so.OwnerId);
                currNotification1.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification1.setTargetId(so.OwnerId); */
                try {
                    system.debug('res.Message_Text2'+response.Message_Text);
                    currNotification.send(new Set<String> {recipientId});
                   // currNotification1.send(new Set<String> {so.OwnerId});
                }
                catch (Exception ex) {
                    System.debug('Notification Failed:' + ex.getMessage());
                }
                
                system.debug('recipientId1'+recipientId1);
                 system.debug('LoginUserID'+LoginUserID);
                // Reinitiate approval process
               Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(so.id);
               // req1.setSubmitterId(so.OwnerId); 
                req1.setSubmitterId(recipientId);
                req1.setProcessDefinitionNameOrId('Order_Cancellation_Approval_Process');
                req1.setSkipEntryCriteria(true);
                     req1.setNextApproverIds(new List<Id> {recipientId1});
                if(!Test.isRunningTest()){
                    Approval.ProcessResult result = Approval.process(req1);
                }
                
                
                so.Order_Status__c = 'Blocked'; //Approved
                so.SDM_Approval_On_Order_Cancellation__c = 0;
                update so;
                
            }
            if(response.Message_Type == 'S' || Test.isRunningTest()){
                SO.Order_Status__c = 'Cancelled';
                SO.SDM_Approval_On_Order_Cancellation__c = 0;
                so.Blocked_Cancellation_Message__c = response.Message_Text;
                system.debug('Blocked_Cancellation_Message__c S'+response.Message_Text);
                if(!test.isRunningTest()){    
                update SO;
                
                }
                
                
                
			if(lstOrderItem.size() > 0){
				for(Sales_Order_Line_Item__c oOrderItem: lstOrderItem){
					setBrandName.add(oOrderItem.SKU_Name__r.Brand_Name__c);
				}
				
				
				Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
				string sBUValue = '5191';
				if(ip1.Sales_Org_BU__c != sBUValue) {
					Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (                                  TerritoryManager__c=: UserInfo.getUserId() 
													  OR Region__r.RegionHead__c=: UserInfo.getUserId()
													  OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()

													  OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
													  OR SBU__r.SBUUser__c=: UserInfo.getUserId()
													  OR BarterManager__c=: UserInfo.getUserId()
													 ) LIMIT 1];
					sBUValue = u.Zone_Code__c;
				}
								
				list<Inventory_Control__c> fy = [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c,Product_Name__c FROM Inventory_Control__c where BU__c =: sBUValue AND  Product__c IN: setBrandName];
				
				list<Inventory_Control__c> lstFYUpdate = new list<Inventory_Control__c>();
				if(fy.size() > 0) {
					for(Inventory_Control__c oFy: fy) {
						decimal count = 0;
						for(Sales_Order_Line_Item__c oItem: lstOrderItem) {
							Date d = oItem.DateofFAT__c;
							string year = string.valueOf(d.year());
							integer y = integer.valueOf(year.remove('20'));
							integer month = d.month();
							string sfy = '';
							if(month >= 4 && month <= 12){
								sfy = string.valueOf(y)+'/'+string.valueOf(y+1);
							}
							else if(month >= 1 && month <= 3){
								sfy = string.valueOf(y-1)+'/'+string.valueOf(y);
							}
							
							if(oFy.Fiscal_Year__c == sfy && oFy.Product__c == oItem.SKU_Name__r.Brand_Name__c) {
								if(oItem.Sale_Order__r.Order_Status__c == 'Rejected') {
									count = count + oItem.Quantity__c;
								}
								else {
									count = count + oItem.Unbilled_Quatity__c;
								}
							}
						}
						if(count > 0){
							oFy.Quantity__c = oFy.Quantity__c + count;
							lstFYUpdate.add(oFy);
						}
					}
				}
				if(lstFYUpdate.size() > 0) {
					update lstFYUpdate;
				}
			}
                
                
                
                
                
                
                
                
            }
        }
        if(SO.SDM_Approval_On_Order_Cancellation__c == 3){
            SalesOrderCancellationRequestWrapper request = new SalesOrderCancellationRequestWrapper();
            request.SAP_Order_Number = SO.SAP_Order_Number__c;
            request.Action = '3';
            request.Rejection_Code = null; // Added by Sagar@Wipro for sending Rejection Code in SAP OC-001 
            SalesOrderCancellationResponseWrapper response = OrderBlocking.OrderBlockingAPICall(request);
            //string sTemp = 'E';
			//if(sTemp == 'E'){
            if(response.Message_Type == 'E'){
                //so.ErrorMessage__c = 'Please check With SAP Admin for unblocking the order'; //response.message
				so.Order_Status__c = 'Blocked';
                SO.SDM_Approval_On_Order_Cancellation__c = 2;
                so.Blocked_Cancellation_Message__c = 'Please check With SAP Admin for unblocking the order' + response.Message_Text;
                update so;
				
				// notification
                List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='SDM_Approval_Error_Notification'];
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                currNotification.setTitle('ERRO  ' +so.SFDC_Order_Number__c);
                currNotification.setBody(response.Message_Text);
                currNotification.setSenderId(recipientId);
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification.setTargetId(recipientId);
                
              /*  Messaging.CustomNotification currNotification1 = new Messaging.CustomNotification();
                currNotification1.setTitle('Error  ' +so.SFDC_Order_Number__c);
                currNotification1.setBody('Please Reinitaite your request');
                currNotification1.setSenderId(so.OwnerId);
                currNotification1.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification1.setTargetId(so.OwnerId); */
                try {
                    system.debug('res.Message_Text2'+response.Message_Text);
                    currNotification.send(new Set<String> {recipientId});
                   // currNotification1.send(new Set<String> {so.OwnerId});
                }
                catch (Exception ex) {
                    System.debug('Notification Failed:' + ex.getMessage());
                }
                
                system.debug('recipientId1'+recipientId1);
                 system.debug('LoginUserID'+LoginUserID);
                // Reinitiate approval process
               Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(so.id);
               // req1.setSubmitterId(so.OwnerId); 
                req1.setSubmitterId(recipientId);
                req1.setProcessDefinitionNameOrId('Order_Cancellation_Approval_Process');
                req1.setSkipEntryCriteria(true);
                     req1.setNextApproverIds(new List<Id> {recipientId1});
                if(!Test.isRunningTest()){
                   Approval.ProcessResult result = Approval.process(req1); 
                }
                
                
                so.Order_Status__c = 'Blocked'; //Approved
                so.SDM_Approval_On_Order_Cancellation__c = 0;
                update so;
                
            }
            if(response.Message_Type == 'S'){
                SO.Order_Status__c = 'Approved';
                SO.SDM_Approval_On_Order_Cancellation__c = 0;
                so.Blocked_Cancellation_Message__c = response.Message_Text;
                update SO;
                
            }   
        }
    }
      
     // Added by Sagar@Wipro for StatusOrdemVendas API Call
    @AuraEnabled	
    Public static void SKUUpdateAPI(String soId){
        SKUBrazilOutboundAPI.SKUUpdate(soId,null,null);
    } 
    
}