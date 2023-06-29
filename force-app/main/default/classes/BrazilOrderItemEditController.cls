/* Name: BrazilOrderItemEditController
/Author: Wipro
/Description: Lightning Component Apex Controller used for Line Item Edit/Cancel and API Callout
/Brazil Price2Win Phase 2 User Stories:  OC-002, SO-007, SO-008z
*/

public class BrazilOrderItemEditController {
   /* @AuraEnabled
    public static List<Sales_Order_Line_Item__c> getAllOrderItem(string soId){
        
        return [Select Id,Name,Item_Number__c ,ProductName__c,SKU_Name__r.SKU_Description__c,Cancellation_Reason__c,Cancel_Line_Item__c,Quantity__c,Unbilled_Quatity__c,DateofFAT__c,Item_Cancel__c,SKU_Name__r.Brand_Name__c,SKU_Name__c,New_Quantity__c,Quantity_Billed__c,Item_Status__c from Sales_Order_Line_Item__c where Sale_Order__c =:soId AND Item_Status__c = 'Active'] ; 
        
    }*/
    @AuraEnabled
    public static List<Sales_Order_Line_Item__c> getAllOrderItem(string soId){
        
        List<Sales_Order_Line_Item__c> soitems= [Select Id,Name,Item_Number__c ,ProductName__c,SKU_Name__r.SKU_Description__c,multipleOf__c,Cancellation_Reason__c,Cancel_Line_Item__c,Quantity__c,Unbilled_Quatity__c,DateofFAT__c,Item_Cancel__c,SKU_Name__r.Brand_Name__c,SKU_Name__c,New_Quantity__c,Quantity_Billed__c,Item_Status__c from Sales_Order_Line_Item__c where Sale_Order__c =:soId AND Item_Status__c = 'Active'] ; 
        for(Sales_Order_Line_Item__c soitem:soitems){
            if(soitem.multipleOf__c ==null){
               soitem.multipleOf__c = 0; 
            }
        }
        return soitems;
    }
    
    @AuraEnabled
    public static Map<String, String> cancelReason(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Sales_Order_Line_Item__c.Cancellation_Reason__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<minMaxDate> getMinMaxDate(string soId){
        
        list<Sales_Order_Line_Item__c> s = getAllOrderItem(soId);
        List<minMaxDate> mnv = new List<minMaxDate>();
        List<String> skulist  = new List<String>();
        
        string regCode;
        List<Territory_Distributor__c> tdList = [SELECT ID, Name, TerritoryCode__c, Region__c,Region__r.RegionCode__c
                                                 FROM Territory_Distributor__c
                                                 WHERE SalesOrg__r.Sales_Org_Code__c = '5191'
                                                 AND (TerritoryManager__c=: UserInfo.getUserId()
                                                      OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                      
                                                      OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                      OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                      OR BarterManager__c=: UserInfo.getUserId()
                                                     ) limit 1];    
        //system.debug('**Territory List --> ' +tdList);
        
        for(Sales_Order_Line_Item__c s1 : s){
            skulist.add(s1.SKU_Name__c);
        }
        
        if(tdList.size()>0){
            regCode = tdList[0].Region__r.RegionCode__c;
            system.debug('**regionCode --> ' +regCode);
        }
        
        list<Brazil_Region_SKU_Combination__c> comboList = new list<Brazil_Region_SKU_Combination__c>();
        if(regCode!=null){
            comboList = [SELECT Id, SKU__c,SKU__r.Name, Sales_District__c, Availability__c,Date__c,Maximum_Date__c FROM Brazil_Region_SKU_Combination__c where Sales_District__r.RegionCode__c =:regCode 
                         AND SKU__c IN :skulist] ;
            system.debug('**List Brazil_Region_SKU_Combination --> ' +comboList);  
            system.debug('**List Region Code --> ' +regCode);
            system.debug('**List SKU --> ' +skulist);
        }  
        for(Brazil_Region_SKU_Combination__c c1 :comboList){
            minMaxDate m1 = new minMaxDate();
            m1.skuName = c1.SKU__r.Name;
            m1.maxDate = c1.Maximum_Date__c;
            m1.minDate = c1.Date__c;
            m1.availability = c1.Availability__c;
            mnv.add(m1);
        }
        return mnv;   
    }   
    
    @AuraEnabled
    public static void updateOrderItem(string soId, String soitString ){
        Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
        List<Sales_Order_Line_Item__c> soit = (List<Sales_Order_Line_Item__c>)JSON.deserialize(soitString, List<Sales_Order_Line_Item__c>.class); 
        system.debug('soit'+soit);
        list<Sales_Order_Line_Item__c> soitList = new list<Sales_Order_Line_Item__c>();
        
        Sales_Order__c SO = [select id, SAP_Order_Number__c from Sales_Order__c where Id=:soId];
        
       /* List<SalesOrderItemBlockingRequestWrapper> sitemsreq = new List<SalesOrderItemBlockingRequestWrapper>();
        for(Sales_Order_Line_Item__c soit1:soit){
            
            SalesOrderItemBlockingRequestWrapper sitem = new SalesOrderItemBlockingRequestWrapper();
            sitem.Item_Number = soit1.Item_Number__c;
            sitem.Order_LineItem_Flag = true;
            sitemsreq.add(sitem);
        }
        
        string itemarray = JSON.serialize(sitemsreq);
*/
        // string SOheader =  '{"SAP_Order_Number__c":'+SO.SAP_Order_Number__c+ ', "Action" : 1, "Order_Flag" : true, "lineItems" : '+itemarray+ '}' ;
        
        SO.SDM_Approval_On_Order_Item_Edit_Cancel__c = false;
        SO.SDM_Rejected_OrderItem_Edit_Approval__c = false;
        /*if(userDetails.Profile.Name == 'Brazil Sales District Manager'){
            SO.SDM_Auto_Approval_Item_Edit_Cancel__c = true;   
        }
        else{
            SO.SDM_Item_Update_Cancel_Status__c = 'Pending';
            SO.Order_Status__c = 'Blocked';
        }*/
        update SO;
        string sapOrderNumber =  SO.SAP_Order_Number__c;                  
        List<Sales_Order_Line_Item__c> soitapi = new List<Sales_Order_Line_Item__c>();
        for(Sales_Order_Line_Item__c soit1:soit){
            Sales_Order_Line_Item__c soit2 = new Sales_Order_Line_Item__c();
            soit2.Id=soit1.Id;
            if(soit1.DateofFAT__c != null){
                soit2.New_Date_of_FAT__c = soit1.DateofFAT__c;
                soit2.Date_Of_FAT_Changed__c = true;
            }
            if(soit1.New_Quantity__c != null){
                soit2.New_Quantity__c = soit1.New_Quantity__c;
                soit2.Quantity_Changed__c = true;   
            }
            soit2.Cancel_Line_Item__c = soit1.Cancel_Line_Item__c;
            soit2.Item_Number__c = soit1.Item_Number__c;
            if(soit1.Cancellation_Reason__c != null){
                soit2.Cancellation_Reason__c = soit1.Cancellation_Reason__c;
            }
            soitList.add(soit2);
        }
        
        for(Sales_Order_Line_Item__c soita:soitList){
            if(soita.Date_Of_FAT_Changed__c==true||soita.Cancel_Line_Item__c==true||soita.Quantity_Changed__c==true){
                soitapi.add(soita);
            }
        }
        OrderItemBlockingCallout(json.serialize(SO),json.serialize(soitapi),1);
        if(!Test.isRunningTest()){
        update soitList;
        }
        
        
            //   OrderItemBlocking.OrderItemBlockingRes response = OrderItemBlocking.OrderItemBlockingAPICall1(SO,soitList,1);
		//string responsetext = response.Message_Text;
      /* if(userDetails.Profile.Name != 'Brazil Sales District Manager'){
            //Approval Process
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('');
            req.setObjectId(soId);
            req.setProcessDefinitionNameOrId('Brazil_Order_Item_Edit_Cancel_Process');
            Approval.ProcessResult result = Approval.process(req);
            
        }*/
   // return  responsetext;
        //update SO;
    }
    
    
    @future(callout=true)
    public static void OrderItemBlockingCallout(string sos,string soilists,integer action){
                Id userId = userinfo.getUserId();
        User userDetails =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];
        list<Sales_Order_Line_Item__c> soitListupdate = new list<Sales_Order_Line_Item__c>();
        Sales_Order__c so = (Sales_Order__c)json.deserialize(sos, Sales_Order__c.class);
        string recipientId = so.SalesDistrictManager__c;
        id recipientId1=so.SalesDistrictManager__c;
        //list<Sales_Order_Line_Item__c> soilist = (list<Sales_Order_Line_Item__c>)json.deserialize(soilists, list<Sales_Order_Line_Item__c>.class);
        list<Sales_Order_Line_Item__c> soitList = (list<Sales_Order_Line_Item__c>)json.deserialize(soilists, list<Sales_Order_Line_Item__c>.class);
        OrderItemBlocking.OrderItemBlockingRes response = OrderItemBlocking.OrderItemBlockingAPICall1(so,soitList,action);
        if(response.Message_Type == 'S' && action == 2){
            system.debug('Test1');
            OrderItemBlocking.OrderItemBlockingRes res = OrderItemChangeCallout(sos,soilists);
            
			if(res.Message_Type == 'E' || Test.isRunningTest()){
                so.LineItem_Edit_Cancel_Message__c = res.Message_Text;
                so.Approval_Reason__c = 'Pedido De Venda - Editar/Cancelar item do pedido';
                system.debug('res.Message_Text2'+res.Message_Text);
                List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='SDM_Approval_Error_Notification'];
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                currNotification.setTitle('ERRO  ' +so.SFDC_Order_Number__c);
                currNotification.setBody(res.Message_Text);
                currNotification.setSenderId(recipientId);
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification.setTargetId(recipientId);
                
                try {
                    system.debug('res.Message_Text2'+res.Message_Text);
                    currNotification.send(new Set<String> {recipientId});
                    //currNotification1.send(new Set<String> {so.OwnerId});
                }
                catch (Exception ex) {
                    System.debug('Notification Failed:' + ex.getMessage());
                }
                
                if(!Approval.isLocked(so.id)){
                   
                // Reinitiate approval process
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(so.id);
                req1.setSubmitterId(recipientId); 
                req1.setProcessDefinitionNameOrId('Brazil_Order_Item_Edit_Cancel_Process');
                //req1.setSkipEntryCriteria(true);
                    req1.setNextApproverIds(new List<Id> {recipientId});
                 if(!Test.isRunningTest()){
                 	Approval.ProcessResult result = Approval.process(req1); 
                 }
                
                  
                    so.Order_Status__c = 'Blocked'; //Approved
               // so.SDM_Approval_On_Order_Cancellation__c = 0;
              
                }
            }
            if(res.Message_Type =='S' || Test.isRunningTest()){
                List<Sales_Order_Line_Item__c> soitems =  [Select Id,Name,Item_Number__c,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,
                                                           Unbilled_Quatity__c,Quantity_Billed__c ,DateofFAT__c,Cancel_Line_Item__c,New_Quantity__c,
                                                           New_Date_of_FAT__c,Date_Of_FAT_Changed__c,Quantity_Changed__c,Cancellation_Reason__c,Item_Status__c 
                                                           from Sales_Order_Line_Item__c where Sale_Order__c =:so.id 
                                                           AND (Date_Of_FAT_Changed__c = true OR Quantity_Changed__c = true OR Cancel_Line_Item__c =true)];
                system.debug('soitems.size()'+soitems.size());
                if(soitems.size() > 0){
                    for(Sales_Order_Line_Item__c soitems1 :soitems){
                        if(soitems1.New_Quantity__c != null){
                            soitems1.Quantity__c=soitems1.New_Quantity__c;
                            system.debug('Test2');
                        }
                        if(soitems1.New_Date_of_FAT__c != null){
                            soitems1.DateofFAT__c=soitems1.New_Date_of_FAT__c;
                            system.debug('Test3');
                        }
                        if(soitems1.Cancel_Line_Item__c == true){
                            soitems1.Item_Status__c = 'Inactive';
                            system.debug('Test4');
                        }
                        soitListupdate.add(soitems1) ;  
                    }
                } 
                so.LineItem_Edit_Cancel_Message__c = res.Message_Text;
                 so.Order_Status__c = 'Approved';
                system.debug('res.Message_Text1'+res.Message_Text);
               
            }
        }
        if(response.Message_Type == 'S' && action == 1){
            if(userDetails.Profile.Name != 'Brazil Sales District Manager'){
                //Approval Process
                system.debug('Test5');
                 if(!Test.isRunningTest()){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('');
                req.setObjectId(so.id);
                req.setProcessDefinitionNameOrId('Brazil_Order_Item_Edit_Cancel_Process');
                Approval.ProcessResult result = Approval.process(req);
                 }
                so.LineItem_Edit_Cancel_Message__c = response.Message_Text;
                so.SDM_Item_Update_Cancel_Status__c = 'Pending';
                so.Order_Status__c = 'Blocked';
                so.Approval_Reason__c = 'Pedido De Venda - Editar/Cancelar item do pedido';
            }
            if(userDetails.Profile.Name == 'Brazil Sales District Manager'){
                SO.SDM_Auto_Approval_Item_Edit_Cancel__c = true;   
            }
            
        }
        if(response.Message_Type == 'E' && action == 1){
            system.debug('Test6');
            so.LineItem_Edit_Cancel_Message__c = response.Message_Text;
        }
        
        if(action == 2 || action == 3){
            system.debug('Test8');
			so.LineItem_Edit_Cancel_Message__c = response.Message_Text;
           // so.Order_Status__c = 'Approved';
            so.SDM_Item_Update_Cancel_Status__c = 'Approved';
        }
        
        if((response.Message_Type == 'E' && action == 3) || Test.isRunningTest()){
            //so.Order_Status__c = 'Approved';
            system.debug('Test7');
            so.LineItem_Edit_Cancel_Message__c = 'Please check With SAP Admin for unblocking the order' + response.Message_Text;
            so.Order_Status__c = 'Blocked'; //Approved
			
			List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='SDM_Approval_Error_Notification'];
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                currNotification.setTitle('ERRO  ' +so.SFDC_Order_Number__c);
                currNotification.setBody(response.Message_Text);
                currNotification.setSenderId(recipientId);
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                currNotification.setTargetId(recipientId);
                
                try {
                    system.debug('response.Message_Text2'+response.Message_Text);
                    currNotification.send(new Set<String> {recipientId});
                    //currNotification1.send(new Set<String> {so.OwnerId});
                }
                catch (Exception ex) {
                    System.debug('Notification Failed:' + ex.getMessage());
                }
                
                if(!Approval.isLocked(so.id)){
                   
                // Reinitiate approval process
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(so.id);
                req1.setSubmitterId(recipientId); 
                req1.setProcessDefinitionNameOrId('Brazil_Order_Item_Edit_Cancel_Process');
                //req1.setSkipEntryCriteria(true);
                    req1.setNextApproverIds(new List<Id> {recipientId});
                if(!Test.isRunningTest()){
                	Approval.ProcessResult result = Approval.process(req1);
                }
                  
                    so.Order_Status__c = 'Blocked'; //Approved
               // so.SDM_Approval_On_Order_Cancellation__c = 0;
              
                }
			
        }
        if((response.Message_Type == 'S' && action == 3) || Test.isRunningTest()){
            system.debug('Test9');
            so.Order_Status__c = 'Approved';
            so.LineItem_Edit_Cancel_Message__c = response.Message_Text;
                List<Sales_Order_Line_Item__c> soitems =  [Select Id,Name,Item_Number__c,ProductName__c,SKU_Name__r.Brand_Name__c,Quantity__c,Unbilled_Quatity__c,DateofFAT__c,Item_Cancel__c,New_Quantity__c,New_Date_of_FAT__c from Sales_Order_Line_Item__c where Sale_Order__c =:so.id];
                for(Sales_Order_Line_Item__c soitems1 :soitems){
                    //soitems1.DateofFAT__c=soitems1.New_Date_of_FAT__c;
                   // soitems1.Quantity__c=soitems1.New_Quantity__c + soitems1.Quantity_Billed__c;
                    soitems1.Quantity_Changed__c=false;
                    soitems1.Date_Of_FAT_Changed__c=false;
                    soitems1.New_Date_of_FAT__c = null;
                    soitems1.New_Quantity__c = null;
                    soitListupdate.add(soitems1) ;  
                }  
        }
      
        //so.Order_Status__c = 'Approved';
        update soitListupdate;
        update so;
        system.debug('response message'+response.Message_Text);
        
    }
    
    //@future(callout=true)
    public static OrderItemBlocking.OrderItemBlockingRes OrderItemChangeCallout(string sos,string soilists){
        Sales_Order__c so = (Sales_Order__c)json.deserialize(sos, Sales_Order__c.class);
        list<Sales_Order_Line_Item__c> soilist = (list<Sales_Order_Line_Item__c>)json.deserialize(soilists, list<Sales_Order_Line_Item__c>.class);
        OrderItemBlocking.OrderItemBlockingRes response = OrderItemBlocking.OrderItemChangeAPICall(so,soilist);
        system.debug('response message'+response.Message_Text);
        return response;
        
    }
    
    /*  @future(callout = true)
public static void OrderUnblockingCallout(string sapOrderNumber){
SalesOrderCancellationRequestWrapper request = new SalesOrderCancellationRequestWrapper();
request.sapOrderNumber = sapOrderNumber;
request.action = '2';

//SalesOrderCancellationResponseWrapper response = OrderBlocking.OrderBlockingAPICall(request);
//  system.debug('response message'+response.message);

}
*/    
    @AuraEnabled
    public static List<Inventory> getInventory() {
        list<String> fyearlist = new list<String>();
        list<String> prolist = new list<String>();
        Decimal total=0;
        Inventory_Parameter1__mdt ip1 = [SELECT id,Sales_Org_BU__c from Inventory_Parameter1__mdt ];
        List<Inventory> iv = new List<Inventory>();
        integer y=0;        
        if(ip1.Sales_Org_BU__c=='5191'){
            list<Inventory_Control__c> ic =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c='5191'];       
            for(Inventory_Control__c i: ic){
                
                Inventory_Parameter2__mdt ip = [SELECT Id, Inventory_Active__c ,Inventory_Block_Alert__c,Brand__c FROM Inventory_Parameter2__mdt where Brand__c=:i.Product__c];                
                String y2 = i.Fiscal_Year__c;
                System.debug('y2= '+y2);
                string y3 = y2.substring(3);
                System.debug('y3= '+y3);
                string y4 = y2.substring(0,2);
                System.debug('y4= '+y4);
                string y5 ='20'+y4+'-04-01';
                System.debug('y5= '+y5);
                String y6= '20'+y3+'-03-31';
                System.debug('y6= '+y6);
                
                Inventory inv = new Inventory();
                inv.year = y5;
                inv.year1 = y6;
                total = i.Quantity__c;
                inv.qty =  i.Quantity__c;
                inv.inventoryactive = ip.Inventory_Active__c;
                inv.inventoryblockalert = ip.Inventory_Block_Alert__c;
                inv.productname = ip.Brand__c;
                
                inv.totalqty = total;
                iv.add(inv);
            }   
        }
        else{            
            Territory_Distributor__c u =[SELECT ID, Name, Zone_Code__c FROM Territory_Distributor__c WHERE SalesOrg__r.Sales_Org_Code__c = '5191' AND TerritoryManagerActive__c = True AND (TerritoryManager__c=: UserInfo.getUserId() 
                                                                                                                                                                                            OR Region__r.RegionHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR Region__r.Brazil_Marketing_Ops_Manager__c=:UserInfo.getUserId()
                                                                                                                                                                                            
                                                                                                                                                                                            OR Zone__r.ZonalHead__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR SBU__r.SBUUser__c=: UserInfo.getUserId()
                                                                                                                                                                                            OR BarterManager__c=: UserInfo.getUserId()
                                                                                                                                                                                           )];
            list<Inventory_Control__c> ic =  [SELECT Id, Quantity__c ,FY__c,Product__c,Fiscal_Year__c FROM Inventory_Control__c where BU__c =: u.Zone_Code__c];
            
            for(Inventory_Control__c i: ic){
                System.debug('i.Product__c'+i.Product__c);
                // String product = i.Product__c;
                Inventory_Parameter2__mdt ip = [SELECT Id, Inventory_Active__c ,Inventory_Block_Alert__c,Brand__c FROM Inventory_Parameter2__mdt where Brand__c =: i.Product__c];
                System.debug('ip'+ip);
                String y2 = i.Fiscal_Year__c;
                System.debug('y2= '+y2);
                string y3 = y2.substring(3);
                System.debug('y3= '+y3);
                string y4 = y2.substring(0,2);
                System.debug('y4= '+y4);
                string y5 ='20'+y4+'-04-01';
                System.debug('y5= '+y5);
                String y6= '20'+y3+'-03-31';
                System.debug('y6= '+y6);
                Inventory inv = new Inventory();
                
                inv.year = y5;
                inv.year1 = y6;
                
                total =  i.Quantity__c;
                inv.inventoryactive = ip.Inventory_Active__c;
                inv.qty =  i.Quantity__c;
                inv.inventoryblockalert = ip.Inventory_Block_Alert__c;
                inv.productname = ip.Brand__c;
                inv.totalqty = total;
                iv.add(inv);
                //i1=i1+1;
            }
        }
        return iv;  
    }
    
    
    public class Inventory {
        @AuraEnabled public Decimal qty;
        @AuraEnabled public Boolean inventoryactive;
        @AuraEnabled public String inventoryblockalert;
        @AuraEnabled public String productname;
        @AuraEnabled public String year;
        @AuraEnabled public String year1;
        
        @AuraEnabled public Decimal totalqty;
        
        
        public Inventory(){
            qty = 0;
            inventoryactive= false;
            inventoryblockalert = '';
            productname='';
            year='';
            year1='';
            totalqty = 0;
        }
        
        
    }
    
    public class minMaxDate {
        @AuraEnabled public String skuName;
        @AuraEnabled public Date minDate;
        @AuraEnabled public Date maxDate;
        @AuraEnabled public String availability;
        
        
        public minMaxDate(){
            skuName = '';
            minDate= null;
            maxDate = null;
            availability='';
            
        }
        
        
    }
    
    
    
    @AuraEnabled
    public static void ClearLineItemFields(string soId){
        Sales_Order__c SO = [select id, SAP_Order_Number__c,SDM_Item_Update_Cancel_Status__c from Sales_Order__c where Id=:soId];
        list<Sales_Order_Line_Item__c> soitemlst = new list<Sales_Order_Line_Item__c>();
        if(SO.SDM_Item_Update_Cancel_Status__c != 'Pending'){
            SO.SDM_Approval_On_Order_Item_Edit_Cancel__c  = false;
            SO.SDM_Rejected_OrderItem_Edit_Approval__c = false;
            SO.SDM_Auto_Approval_Item_Edit_Cancel__c = false;
            system.debug('Test1');
            update SO;
            system.debug('Test2');
            for(Sales_Order_Line_Item__c soitems : [Select Id,Name ,ProductName__c,New_Date_of_FAT__c,New_Quantity__c,Date_Of_FAT_Changed__c,Quantity_Changed__c,Cancel_Line_Item__c from Sales_Order_Line_Item__c where Sale_Order__c =:soId]){
                soitems.New_Date_of_FAT__c = null;
                soitems.New_Quantity__c = null;
                soitems.Date_Of_FAT_Changed__c = false;
                soitems.Quantity_Changed__c = false;
                soitems.Cancel_Line_Item__c =false;
                soitemlst.add(soitems);
            }
            system.debug('Test3');
            update soitemlst;
            system.debug('Test4');
        }
    }
     @AuraEnabled
    public static string OrderItemBlockingAPICallaction1(string soId,string soitString){
      string cpimsg = OrderItemBlocking.OrderItemBlockingAPICall2(soId,soitString);
        system.debug('cpimsg****'+cpimsg);
        return cpimsg;
    }
    
}