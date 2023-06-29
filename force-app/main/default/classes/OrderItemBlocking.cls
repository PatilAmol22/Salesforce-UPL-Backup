/* Name: OrderItemBlocking
/Author: Wipro
/Description: Sales Order Line Item Blocking API
/Brazil Price2Win Phase 2 User Stories: 
*/


public class OrderItemBlocking {
    /*@InvocableMethod
public static void callOrderCancel(list<id> ids){
Sales_Order__c so = [select id, SAP_Order_Number__c,SDM_Item_Update_Cancel_Status__c from Sales_Order__c where Id in :ids limit 1];
List<Sales_Order_Line_Item__c> soit = [Select Id,Name,Item_Number__c ,ProductName__c,Cancellation_Reason__c,Cancel_Line_Item__c,Quantity__c,Unbilled_Quatity__c,DateofFAT__c,Item_Cancel__c,SKU_Name__r.Brand_Name__c,SKU_Name__c,Non_Invoice_Quantity__c,New_Quantity__c,Quantity_Billed__c from Sales_Order_Line_Item__c where Sale_Order__c =:so.Id];
if(){

}
}*/
    public static OrderItemBlockingRes OrderItemBlockingAPICall1(Sales_Order__c so,List<Sales_Order_Line_Item__c> soit,integer action){
        
        String username = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Username__c;
        String password = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Passward__c; 
        String tokenacessurl = UPL_Settings__c.getOrgDefaults().Token_Access_Endpoint_Price2Win__c;
        String orderblocking = UPL_Settings__c.getOrgDefaults().Price2Win_SalesOrderBlockItem_Endpoint__c;
        
        OrderItemBlockingRes CPIres;
        wrapOauthResponse wrapOauthResponseObj;
        string oathRes;
        string res;
        OrderItemBlockingReq reqBody = new OrderItemBlockingReq();
        reqBody.SAP_Order_Number = so.SAP_Order_Number__c;
        reqBody.Action = action;
        reqBody.Order_Flag = '';
        system.debug('sales order '+so);
        system.debug('Sales items '+soit);
        List<lineItem> lilst = new List<lineItem>();
        if(!Test.isRunningTest()){
            for(Sales_Order_Line_Item__c soi: soit){
                lineItem li = new lineItem();
                li.Item_Number = soi.Item_Number__c.intValue();
                //if(soi.Quantity_Changed__c== true || soi.Cancel_Line_Item__c== true || soi.Date_Of_FAT_Changed__c== true){ // commented If/Else for RITM0543699 GRZ(Butesh Singla) 04-25-2023
                li.Order_LineItem_Flag = 'X';
                //}
                //else{
               //  li.Order_LineItem_Flag = null;    
               // }
                lilst.add(li);
            }
        }
        else{
            lineItem li = new lineItem();
            li.Item_Number =000010;
            li.Order_LineItem_Flag = 'X';
            lilst.add(li);
        }
        reqBody.lineItems = lilst;
        string finalrequest=json.serialize(reqBody);
        system.debug('OrderItemBlock Call Request:'+finalrequest);
        
        string samplereq =  '{"status": "Success", "message": "No Error"}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setMethod('POST');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        request.setEndpoint(tokenacessurl);   
        HttpResponse response = new HttpResponse(); 
        if(!Test.isRunningTest()){
            response = http.send(request);
        }
        else{
            response.setBody('{"access_token": "9937fe13fc1c182ec316273870c5b1d","token_type": "Bearer","expires_in": 1800,"scope": ""}');
        }
        
        oathRes = response.getBody();
        system.debug('OrderItemBlock Call Response:'+response.getBody());
        wrapOauthResponseObj= (wrapOauthResponse) System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        request.setEndpoint(orderblocking);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        request.setTimeout(120000);
        request.setBody(finalrequest);
        HttpResponse response1 = new HttpResponse();
        if(!Test.isRunningTest()){
            response1 = http.send(request);
        }
        else {
            response1.setBody('{"Error":"","Message_Type":"S","Message_Text":"Alteração processada com sucesso."}');
        }
        res=response1.getBody();
        system.debug('OrderItemBlock Call Request:'+finalrequest);
        system.debug('OrderItemBlock Call Response:'+res);
        CPIres= (OrderItemBlockingRes) System.JSON.deserialize(res, OrderItemBlockingRes.class);
        return CPIres;
    }
    
    public static string OrderItemBlockingAPICall2(string soId,string soitString){
        system.debug('***soitString***'+soitString);
        String username = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Username__c;
        String password = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Passward__c; 
        String tokenacessurl = UPL_Settings__c.getOrgDefaults().Token_Access_Endpoint_Price2Win__c;
        String orderblocking = UPL_Settings__c.getOrgDefaults().Price2Win_SalesOrderBlockItem_Endpoint__c;
        
        
        Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
        List<Sales_Order_Line_Item__c> soit = (List<Sales_Order_Line_Item__c>)JSON.deserialize(soitString, List<Sales_Order_Line_Item__c>.class); 
        system.debug('soit'+soit);
        list<Sales_Order_Line_Item__c> soitList = new list<Sales_Order_Line_Item__c>();
        Sales_Order__c SO = [select id, SAP_Order_Number__c from Sales_Order__c where Id=:soId];
        List<lineItem> linereqlst = new List<lineItem>();
        string sapOrderNumber =  SO.SAP_Order_Number__c;                  
        List<Sales_Order_Line_Item__c> soitapi = new List<Sales_Order_Line_Item__c>();
        for(Sales_Order_Line_Item__c soit1:soit){
            Sales_Order_Line_Item__c soit2 = new Sales_Order_Line_Item__c();
            soit2.Id=soit1.Id;
            lineItem linereq = new lineItem();
            linereq.Item_Number = soit1.Item_Number__c.intValue();
            linereq.Order_LineItem_Flag = null;
            if(soit1.New_Date_of_FAT__c != null){
                soit2.New_Date_of_FAT__c = soit1.New_Date_of_FAT__c;
                soit2.Date_Of_FAT_Changed__c = true;
                linereq.Order_LineItem_Flag = 'X';
            }
            if(soit1.New_Quantity__c != null){
                soit2.New_Quantity__c = soit1.New_Quantity__c;
                soit2.Quantity_Changed__c = true;  
                linereq.Order_LineItem_Flag = 'X';
            }
            soit2.Cancel_Line_Item__c = soit1.Cancel_Line_Item__c;
            soit2.Item_Number__c = soit1.Item_Number__c;
            if(soit1.Cancellation_Reason__c != null){
                soit2.Cancellation_Reason__c = soit1.Cancellation_Reason__c;
                linereq.Order_LineItem_Flag = 'X';
            }
            soitList.add(soit2);
            linereqlst.add(linereq);
        }
        system.debug('linereqlst'+linereqlst);
         system.debug('linereqlst'+json.serialize(linereqlst));
        for(Sales_Order_Line_Item__c soita:soitList){
            if(soita.Date_Of_FAT_Changed__c==true||soita.Cancel_Line_Item__c==true||soita.Quantity_Changed__c==true){
                soitapi.add(soita);
            }
        }
        //OrderItemBlockingCallout(json.serialize(SO),json.serialize(soitapi),1);
        /*  if(!Test.isRunningTest()){
update soitList;
}*/
        
        
        
        
        
        OrderItemBlockingRes CPIres;
        wrapOauthResponse wrapOauthResponseObj;
        string oathRes;
        string res;
        OrderItemBlockingReq reqBody = new OrderItemBlockingReq();
        reqBody.SAP_Order_Number = so.SAP_Order_Number__c;
        reqBody.Action = 1;
        reqBody.Order_Flag = '';
        system.debug('sales order '+so);
        system.debug('Sales items '+soit);
        List<lineItem> lilst = new List<lineItem>();
        if(!Test.isRunningTest()){
            system.debug('soitapi***Sagar'+soitapi);
            for(Sales_Order_Line_Item__c soi: soitapi){
                lineItem li = new lineItem();
                li.Item_Number = soi.Item_Number__c.intValue();
                //li.Order_LineItem_Flag = 'X';
                if(soi.Quantity_Changed__c== true || soi.Cancel_Line_Item__c== true || soi.Date_Of_FAT_Changed__c== true){
                li.Order_LineItem_Flag = 'X';
                    system.debug('soitapi***Sagar1');
                }
                else{
                 li.Order_LineItem_Flag = null; 
                    system.debug('soitapi***Sagar2');
                }
                lilst.add(li);
            }
        }
        else{
            lineItem li = new lineItem();
            li.Item_Number =000010;
            li.Order_LineItem_Flag = 'X';
            lilst.add(li);
        }
        reqBody.lineItems = lilst;
        string finalrequest=json.serialize(reqBody);
        system.debug('OrderItemBlock Call Request:'+finalrequest);
        
        string samplereq =  '{"status": "Success", "message": "No Error"}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setMethod('POST');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        request.setEndpoint(tokenacessurl);   
        HttpResponse response = new HttpResponse(); 
        if(!Test.isRunningTest()){
            response = http.send(request);
        }
        else{
            response.setBody('{"access_token": "9937fe13fc1c182ec316273870c5b1d","token_type": "Bearer","expires_in": 1800,"scope": ""}');
        }
        
        oathRes = response.getBody();
        system.debug('OrderItemBlock Call Response:'+response.getBody());
        wrapOauthResponseObj= (wrapOauthResponse) System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        request.setEndpoint(orderblocking);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        request.setTimeout(120000);
        request.setBody(finalrequest);
        HttpResponse response1 = new HttpResponse();
        if(!Test.isRunningTest()){
            response1 = http.send(request);
        }
        else {
            response1.setBody('{"Error":"","Message_Type":"S","Message_Text":"Alteração processada com sucesso."}');
        }
        res=response1.getBody();
        system.debug('OrderItemBlock Call Request:'+finalrequest);
        system.debug('OrderItemBlock Call Response:'+res);
        CPIres= (OrderItemBlockingRes) System.JSON.deserialize(res, OrderItemBlockingRes.class);
        string CPIMsg = CPIres.Message_Text ;
        
        if(CPIres.Message_Type == 'E'){
            system.debug('Test6');
            SO.LineItem_Edit_Cancel_Message__c = CPIres.Message_Text;
        }
        
        if(CPIres.Message_Type == 'S'){
            if(userDetails.Profile.Name == 'Brazil Sales District Manager'){
                SO.SDM_Auto_Approval_Item_Edit_Cancel__c = true;   
            }
            
            if(userDetails.Profile.Name != 'Brazil Sales District Manager'){
                //Approval Process
                system.debug('Test5');
               
                SO.LineItem_Edit_Cancel_Message__c = CPIres.Message_Text;
                SO.SDM_Item_Update_Cancel_Status__c = 'Pending';
                SO.Order_Status__c = 'Blocked';
                //SO.Approval_Reason__c = 'Pedido De Venda - OrderItem Edit/Cancel';
                 
            }
            
        }
        
        try{
            system.debug('**Test Test so**');
            update SO;
            system.debug('**Test1 Test1 so1**');
            if(!Test.isRunningTest()){
                system.debug('**Test1 soitList1**'+soitList);
                update soitList;
                system.debug('**Test soitList**');
            }
        }
        catch(Exception ex){
            System.debug('there is a Exception'+ex.getMessage());
        }
        
        if(CPIres.Message_Type == 'S'){
            if(userDetails.Profile.Name != 'Brazil Sales District Manager'){
        if(!Test.isRunningTest()){
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    req.setComments('');
                    req.setObjectId(SO.id);
                    req.setProcessDefinitionNameOrId('Brazil_Order_Item_Edit_Cancel_Process');
                    Approval.ProcessResult result = Approval.process(req);
                }
            }
        }
        
        
        return CPIMsg;
    }
    
    
    
    public static OrderItemBlockingRes OrderItemChangeAPICall(Sales_Order__c so,List<Sales_Order_Line_Item__c> soit){
        
        String username = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Username__c;
        String password = UPL_Settings__c.getOrgDefaults().Price2Win_Oauth_Passward__c; 
        String tokenacessurl = UPL_Settings__c.getOrgDefaults().Token_Access_Endpoint_Price2Win__c;
        String orderblocking = UPL_Settings__c.getOrgDefaults().Price2Win_SalesOrderChange_Endpoint__c;
        list<Sales_Order_Line_Item__c> soitList = new list<Sales_Order_Line_Item__c>();
        
        OrderItemBlockingRes CPIres;
        wrapOauthResponse wrapOauthResponseObj;
        string oathRes;
        string res;
        
        OrderItemChangeReq reqBody = new OrderItemChangeReq();
        reqBody.SAP_Order_Number = so.SAP_Order_Number__c;
        // reqBody.Action = action;
        reqBody.Order_Flag = '';
        system.debug('sales order '+so);
        system.debug('Sales items '+soit);
        List<lineItemChange> lilst = new List<lineItemChange>();
        for(Sales_Order_Line_Item__c soi: soit){
            lineItemChange li = new lineItemChange();
            if(!Test.isRunningTest()){
                li.Item_Number = soi.Item_Number__c.intValue();
            }
            else{
                li.Item_Number = 000010;    
            }
            if( soi.New_Quantity__c != null){
                li.New_Quanity = soi.New_Quantity__c;
                li.Change_Quanity_Flag = 'X';
            }
            else{
                li.New_Quanity = 0.0;
                li.Change_Quanity_Flag = null;    
            }
            
            if(soi.Cancel_Line_Item__c == true){
                li.Rejection_Code = soi.Cancellation_Reason__c;
                system.debug('li.Rejection_Code'+li.Rejection_Code);
                li.Rejection_Code_Flag = 'X';
            }
            else{
                li.Rejection_Code = null;
                system.debug('li.Rejection_Code'+li.Rejection_Code);
                li.Rejection_Code_Flag = null;   
            }
            if(soi.New_Date_of_FAT__c != null){
                li.New_Billing_Date = soi.New_Date_of_FAT__c;
                li.Change_Billing_Date_Flag = 'X';
            }
            else{
                li.New_Billing_Date = null;
                li.Change_Billing_Date_Flag = null;
            }
            lilst.add(li);
        }
        reqBody.lineItems = lilst;
        string finalrequest=json.serialize(reqBody);
        system.debug(finalrequest);
        
        
        // string samplereq =  '{"status": "Success", "message": "No Error"}';
        Http http = new Http();
        HttpRequest request = new HttpRequest();    
        request.setMethod('POST');
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', 'Basic ' +EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password)));
        request.setEndpoint(tokenacessurl);   
        HttpResponse response = new HttpResponse(); 
        if(!Test.isRunningTest()){
            response = http.send(request);
        }
        else{
            response.setBody('{"access_token": "9937fe13fc1c182ec316273870c5b1d","token_type": "Bearer","expires_in": 1800,"scope": ""}');
        }
        // response = http.send(request);   
        oathRes = response.getBody();
        system.debug('response from webservice is '+response.getBody());
        wrapOauthResponseObj= (wrapOauthResponse) System.JSON.deserialize(oathRes, wrapOauthResponse.class);
        request.setEndpoint(orderblocking);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' +wrapOauthResponseObj.access_token);
        request.setBody(finalrequest);
        HttpResponse response1 = new HttpResponse();
        if(!Test.isRunningTest()){
            response1 = http.send(request);
        }
        else {
            response1.setBody('{"Error":"","Message_Type":"S","Message_Text":"Alteração processada com sucesso."}');
        }
        
        res=response1.getBody();
        system.debug('OrderItemChange API Call Request:'+finalrequest);
        system.debug('OrderItemChange API Call Response:'+res);
        CPIres= (OrderItemBlockingRes) System.JSON.deserialize(res, OrderItemBlockingRes.class);
        if(CPIres.Message_Type == 'S'){
            
            
            List<Sales_Order_Line_Item__c> soitemsDOF =  [Select Id,Name ,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,
                                                          Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,
                                                          New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c from Sales_Order_Line_Item__c 
                                                          where Sale_Order__c =:so.id AND Date_Of_FAT_Changed__c = true AND
                                                          Quantity_Changed__c = false AND Cancel_Line_Item__c = false];
            if(soitemsDOF.size() > 0){
                SalesOrderLineItemTriggerHandler.changedateofFAT(soitemsDOF);
                System.debug('changedateofFAT'); 
                
            }
            
            List<Sales_Order_Line_Item__c> soitemsCancelItem =  [Select Id,Name ,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,
                                                                 Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,
                                                                 New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c from Sales_Order_Line_Item__c 
                                                                 where Sale_Order__c =:so.id AND Date_Of_FAT_Changed__c = false AND
                                                                 Quantity_Changed__c = false AND Cancel_Line_Item__c = true];
            
            if(soitemsCancelItem.size() > 0){
                System.debug('CancelItemHandle'); 
                SalesOrderLineItemTriggerHandler.CancelItemHandle(soitemsCancelItem);
                
            }
            
            List<Sales_Order_Line_Item__c> soitemsQtyChange =  [Select Id,Name ,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,
                                                                Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,
                                                                New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c from Sales_Order_Line_Item__c 
                                                                where Sale_Order__c =:so.id AND Date_Of_FAT_Changed__c = false AND
                                                                Quantity_Changed__c = true AND Cancel_Line_Item__c = false];
            
            if(soitemsQtyChange.size() > 0){
                SalesOrderLineItemTriggerHandler.QuantityChangeHandle(soitemsQtyChange);
                System.debug('QuantityChangeHandle'); 
                
            }
            
            List<Sales_Order_Line_Item__c> soitemsQtyDoFChange =  [Select Id,Name ,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,
                                                                   Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,
                                                                   New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c from Sales_Order_Line_Item__c 
                                                                   where Sale_Order__c =:so.id AND Date_Of_FAT_Changed__c = true AND
                                                                   Quantity_Changed__c = true AND Cancel_Line_Item__c = false];
            
            if(soitemsQtyDoFChange.size() > 0){
                System.debug('changeDOFQTY'); 
                SalesOrderLineItemTriggerHandler.changeDOFQTY(soitemsQtyDoFChange);
                
            }
            
        }
        
        update so;
        return CPIres;
        
    }
    
    public class wrapOauthResponse{
        @AuraEnabled
        public String access_token{get;set;}
        @AuraEnabled
        public String token_type{get;set;}
        @AuraEnabled
        public String expires_in{get;set;}
        @AuraEnabled
        public String scope{get;set;}  
        
        public wrapOauthResponse(){
            access_token='';
            token_type='';
            expires_in='';  
            scope='';    
        }
    }
    
    public class OrderItemBlockingReq{
        public string SAP_Order_Number{get;set;}
        public integer Action{get;set;}
        public String Order_Flag{get;set;}
        public List<lineItem> lineItems;
        public OrderItemBlockingReq(){
            lineItems = new List<lineItem>();
        }
        
    }
    public class lineItem{
        public integer Item_Number;
        public string Order_LineItem_Flag;
    }
    
    public class OrderItemBlockingRes{
        public string Error{get;set;}
        public string Message_Type{get;set;}
        public string Message_Text{get;set;}
    }
    
    public class OrderItemChangeReq{
        public string SAP_Order_Number{get;set;}
        public string Order_Flag{get;set;}
        public List<lineItemChange> lineItems;
        public OrderItemChangeReq(){
            lineItems = new List<lineItemChange>();
        }
        
    }
    
    public class lineItemChange{
        public integer Item_Number;
        public decimal New_Quanity;
        public string Change_Quanity_Flag;
        public string Rejection_Code;
        public string Rejection_Code_Flag;
        public Date New_Billing_Date;
        //public string New_Billing_Date{get;set;}
        public string Change_Billing_Date_Flag;
    }
    
    
}