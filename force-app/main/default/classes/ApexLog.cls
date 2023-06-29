/*
* Name: ApexLog
* Created On: 28 Aug 2016
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Utility Class is used for Logging Errors/Exceptions on Order Pages for India/Indonesia/SWAL/Argentina
* Supporting Classes: ApexLogTest for Test Coverage
*/
global class ApexLog {
    //Added by ankita
    global static void KYCExceptionHandler(Exception exObj, String accountId){
        if(exObj != null){
            Monitor_Log__c monObj = new Monitor_Log__c();

            Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('KYC').getRecordTypeId();
            monObj.RecordTypeId = recordTypeId;
            if(exObj!=null){
                monObj.Line_Number__c = exObj.getLineNumber();
                monObj.Message__c = exObj.getMessage();
                monObj.Cause__c = String.valueOf(exObj.getCause());
                monObj.Stack_Trace__c = exObj.getStackTraceString();
                
                String trace = exObj.getStackTraceString().substringAfter('\n');
                monObj.Module__c = getClassName(trace);
                monObj.Method__c = getMethod(trace);
                
                monObj.Distributor__c = accountId;
                monObj.User__c = UserInfo.getUserId();
            }
            upsert monObj;  
            
            if(exObj!=null){
                DateTime d = DateTime.Now() ;
                String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                System.debug(dateString);
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = 'KYC Exception '+dateString+'.log';
                attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
        }
   }
    //Change end
    
    //Method to handle & monitor Exceptions
    global static void exceptionHandler(Exception exObj, Id orderId, Id accountId){
        if(exObj!=null && orderId!=null){ //added orderId null check moumita.
        //if(exObj!=null){
       
        system.debug('exObj is********'+exObj);
            List<Monitor_Log__c> monList = [SELECT Id FROM Monitor_Log__c WHERE Order__c=:orderId];
            String trace = exObj.getStackTraceString().substringAfter('\n');
            Monitor_Log__c monObj = new Monitor_Log__c();
            if(!monList.isEmpty())
                monObj.Id = monList[0].Id;
            else
                monObj.Name = 'Order Module';
            if(String.isNotBlank(orderId)){
                List<Order__c> ordList = [Select Id from Order__c where Id=:orderId];
                if(!ordList.isEmpty())
                    monObj.Order__c = orderId;
            }
            monObj.Line_Number__c = exObj.getLineNumber();
            monObj.Message__c = exObj.getMessage();
            monObj.Cause__c = String.valueOf(exObj.getCause());
            monObj.Stack_Trace__c = exObj.getStackTraceString();
            monObj.Module__c = getClassName(trace);
            monObj.Method__c = getMethod(trace);
            monObj.Distributor__c = accountId;
            monObj.User__c = UserInfo.getUserId();
            upsert monObj;
            
            /*if(monList.isEmpty()){
            Attachment attObj = new Attachment();
            attObj.Name = String.valueOf('SKU '+System.now())+'.log';
            attObj.Body = Blob.valueOf(skuJson);
            attObj.ParentId = monObj.Id;
            insert attObj;
            
            Attachment attObj2 = new Attachment();
            attObj2.Name = String.valueOf('Distributor '+System.now())+'.log';
            attObj2.Body = Blob.valueOf(distributorJSON);
            attObj2.ParentId = monObj.Id;
            insert attObj2;
            
            Attachment attObj3 = new Attachment();
            attObj3.Name = String.valueOf('Shipping '+System.now())+'.log';
            attObj3.Body = Blob.valueOf(shippingJSON);
            attObj3.ParentId = monObj.Id;
            insert attObj3;
            }*/
            
            DateTime d = DateTime.Now() ;
            String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
            System.debug(dateString);
            
            Attachment attObj4 = new Attachment();
            attObj4.Name = 'Exception '+dateString+'.log';
            attObj4.Body = Blob.valueOf(JSON.serialize(monObj));
            attObj4.ParentId = monObj.Id;
            insert attObj4;
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, monObj.Line_Number__c+' - '+monObj.Method__c+' : '+monObj.Message__c));
            if(String.isNotBlank(monObj.Message__c)){
                if(!monObj.Message__c.containsIgnoreCase('SELECT') && !monObj.Message__c.startsWith('?'))
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An unexpected error has occurred. Please contact your System Administrator.'));
            }
            System.debug('Exception: '+exObj.getMessage()+ ' Line Number: '+exObj.getLineNumber());
        }
    }
    
    
    //This Exception handler is for EditSalesOrder  Added by vishal pawar 15-05-2018
    global static void exceptionHandlerForSalesOrder(Exception exObj, Id salesOrderId, Id accountId){
        if(exObj!=null){
                List<Monitor_Log__c> monList = [SELECT Id FROM Monitor_Log__c WHERE Sales_Order__c=:salesOrderId];
                String trace = exObj.getStackTraceString().substringAfter('\n');
                Monitor_Log__c monObj = new Monitor_Log__c();
            
                if(!monList.isEmpty())
                        monObj.Id = monList[0].Id;
                else
                    monObj.Name = 'Sale Order Module';
            
            if(String.isNotBlank(salesOrderId)){
                List<Sales_Order_Line_Item__c> sordList = [Select Id from Sales_Order_Line_Item__c where Id=:salesOrderId];
             
                if(!sordList.isEmpty())
                    monObj.Sales_Order__c = salesOrderId;
                 }
                    monObj.Line_Number__c = exObj.getLineNumber();
                    monObj.Message__c = exObj.getMessage();
                    monObj.Cause__c = String.valueOf(exObj.getCause());
                    monObj.Stack_Trace__c = exObj.getStackTraceString();
                    monObj.Module__c = getClassName(trace);
                    monObj.Method__c = getMethod(trace);
                    monObj.Distributor__c = accountId;
                    monObj.User__c = UserInfo.getUserId();
                    upsert monObj;
                    
                    DateTime d = DateTime.Now() ;
                    String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                    System.debug(dateString);
                    
                    Attachment attObj4 = new Attachment();
                    attObj4.Name = 'Exception '+dateString+'.log';
                    attObj4.Body = Blob.valueOf(JSON.serialize(monObj));
                    attObj4.ParentId = monObj.Id;
                    insert attObj4;
                    
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, monObj.Line_Number__c+' - '+monObj.Method__c+' : '+monObj.Message__c));
                    if(String.isNotBlank(monObj.Message__c)){
                        if(!monObj.Message__c.containsIgnoreCase('SELECT') && !monObj.Message__c.startsWith('?'))
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An unexpected error has occurred. Please contact your System Administrator.'));
                    }
                     System.debug('Exception: '+exObj.getMessage()+ ' Line Number: '+exObj.getLineNumber());
            
        }
                
}

    
    
    
    
    global static String getClassName(String line){
        if (line.startsWith('Class.'))
            line = line.substringAfter('Class.');
        return line.substringBefore(':').substringBeforeLast('.');
    }    
    
    global static String getMethod(String line){
        return line.substringBefore(':').substringAfterLast('.');
    }
    
    public static void exceptionCoverage(Boolean throwEx){
        if(Test.isRunningTest() && throwEx==true){Integer x=1/0;}
    }
    
    //Method to handle & monitor Exceptions
    global static void exceptionHandlerBrazil(Exception exObj, Id accountId, Sales_Order__c soObj, String salesOrderItemString){
        if(soObj!=null){
            Monitor_Log__c monObj = new Monitor_Log__c();

            Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Brazil').getRecordTypeId();
            monObj.RecordTypeId = recordTypeId;
            if(exObj!=null){
                monObj.Line_Number__c = exObj.getLineNumber();
                monObj.Message__c = exObj.getMessage();
                monObj.Cause__c = String.valueOf(exObj.getCause());
                monObj.Stack_Trace__c = exObj.getStackTraceString();
                
                String trace = exObj.getStackTraceString().substringAfter('\n');
                monObj.Module__c = getClassName(trace);
                monObj.Method__c = getMethod(trace);
                
                monObj.Distributor__c = accountId;
                monObj.User__c = UserInfo.getUserId();
            }
            upsert monObj;  
            
            if(exObj!=null){
                DateTime d = DateTime.Now() ;
                String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                System.debug(dateString);
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = 'Exception '+dateString+'.log';
                attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
            
            if(soObj!=null){
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Sales Order'+System.now())+'.log';
                attObj.Body = Blob.valueOf(JSON.serializePretty(soObj));
                attObj.ParentId = monObj.Id;
                insert attObj;
                
                if(String.isNotBlank(salesOrderItemString)){
                    Attachment attObj2 = new Attachment();
                    attObj2.Name = String.valueOf('Line Items '+System.now())+'.log';
                    attObj2.Body = Blob.valueOf(salesOrderItemString);
                    attObj2.ParentId = monObj.Id;
                    insert attObj2;
                }
            }
        }
    }
    
    
  //Added by GRZ(Butesh) for RITM0515253 modified 13-03-2023
    //Method to handle & monitor Exceptions
    global static void exceptionHandlerPoland(Exception exObj, Id accountId, Sales_Order__c soObj, String salesOrderItemString, String additionalDatails){
        //if(soObj!=null){
        Monitor_Log__c monObj = new Monitor_Log__c();
        
        //  Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Brazil').getRecordTypeId();
        // monObj.RecordTypeId = recordTypeId;
        if(exObj!=null){
            monObj.Line_Number__c = exObj.getLineNumber();
            monObj.Message__c = exObj.getMessage();
            monObj.Cause__c = String.valueOf(exObj.getCause());
            monObj.Stack_Trace__c = exObj.getStackTraceString();
            
            String trace = exObj.getStackTraceString().substringAfter('\n');
            monObj.Module__c = getClassName(trace);
            monObj.Method__c = getMethod(trace);
        }
        monObj.Distributor__c = accountId;
        monObj.User__c = UserInfo.getUserId();
        monObj.Additional_Details__c = additionalDatails;
        upsert monObj;  
        
        //if(exObj!=null){
        DateTime d = DateTime.Now() ;
        String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
        System.debug(dateString);
        if(Schema.sObjectType.Attachment.isCreateable() && Schema.sObjectType.Attachment.fields.name.isCreateable() && Schema.sObjectType.Attachment.fields.Body.isCreateable() && Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
            Attachment attObj3 = new Attachment();
            attObj3.Name = 'Exception '+dateString+'.log';
            attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
            attObj3.ParentId = monObj.Id;
            
            insert attObj3;
            
            //}
            
            //if(soObj!=null){
            Attachment attObj = new Attachment();
            attObj.Name = String.valueOf('Sales Order'+System.now())+'.log';
            if(soObj!=null){
                attObj.Body = Blob.valueOf(JSON.serializePretty(soObj));
            }else{
                attObj.Body = Blob.valueOf('Empty');
            }
            attObj.ParentId = monObj.Id;
            insert attObj;
            
            
            Attachment attObj2 = new Attachment();
            attObj2.Name = String.valueOf('Line Items '+System.now())+'.log';
            if(String.isNotBlank(salesOrderItemString)){
                attObj2.Body = Blob.valueOf(salesOrderItemString);
            }else{
                attObj2.Body = Blob.valueOf('Empty');
            }
            attObj2.ParentId = monObj.Id;
            insert attObj2;
        }
        //}
        //}
    }
    
    
    //Method to Log for Colombia Orders.
    global static void exceptionHandlerColumbia(Exception exObj, Id accountId, Sales_Order__c soObj, String salesOrderItemString){
        if(soObj!=null){
            Monitor_Log__c monObj = new Monitor_Log__c();

            if(exObj!=null){
                monObj.Line_Number__c = exObj.getLineNumber();
                monObj.Message__c = exObj.getMessage();
                monObj.Cause__c = String.valueOf(exObj.getCause());
                monObj.Stack_Trace__c = exObj.getStackTraceString();
                
                String trace = exObj.getStackTraceString().substringAfter('\n');
                monObj.Module__c = getClassName(trace);
                monObj.Method__c = getMethod(trace);
                
                monObj.Distributor__c = accountId;
                monObj.User__c = UserInfo.getUserId();
            }
            upsert monObj;  
            
            if(exObj!=null){
                DateTime d = DateTime.Now() ;
                String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                System.debug(dateString);
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = 'Exception '+dateString+'.log';
                attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
            
            if(soObj!=null){
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Sales Order'+System.now())+'.log';
                attObj.Body = Blob.valueOf(JSON.serializePretty(soObj));
                attObj.ParentId = monObj.Id;
                insert attObj;
                
                if(String.isNotBlank(salesOrderItemString)){
                    Attachment attObj2 = new Attachment();
                    attObj2.Name = String.valueOf('Line Items '+System.now())+'.log';
                    attObj2.Body = Blob.valueOf(salesOrderItemString);
                    attObj2.ParentId = monObj.Id;
                    insert attObj2;
                }
            }
        }
    }
    
     //Method to Log for Colombia Orders.
    global static void exceptionHandlerItaly(Exception exObj, Id accountId, Sales_Order__c soObj, String salesOrderItemString){
        if(soObj!=null){
            Monitor_Log__c monObj = new Monitor_Log__c();

            if(exObj!=null){
                monObj.Line_Number__c = exObj.getLineNumber();
                monObj.Message__c = exObj.getMessage();
                monObj.Cause__c = String.valueOf(exObj.getCause());
                monObj.Stack_Trace__c = exObj.getStackTraceString();
                
                String trace = exObj.getStackTraceString().substringAfter('\n');
                monObj.Module__c = getClassName(trace);
                monObj.Method__c = getMethod(trace);
                
                monObj.Distributor__c = accountId;
                monObj.User__c = UserInfo.getUserId();
            }
            upsert monObj;  
            
            if(exObj!=null){
                DateTime d = DateTime.Now() ;
                String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                System.debug(dateString);
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = 'Exception '+dateString+'.log';
                attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
            
            if(soObj!=null){
                Attachment attObj = new Attachment();
                attObj.Name = String.valueOf('Sales Order'+System.now())+'.log';
                attObj.Body = Blob.valueOf(JSON.serializePretty(soObj));
                attObj.ParentId = monObj.Id;
                insert attObj;
                
                if(String.isNotBlank(salesOrderItemString)){
                    Attachment attObj2 = new Attachment();
                    attObj2.Name = String.valueOf('Line Items '+System.now())+'.log';
                    attObj2.Body = Blob.valueOf(salesOrderItemString);
                    attObj2.ParentId = monObj.Id;
                    insert attObj2;
                }
            }
        }
    }
    
    //Method to log request/response for HANA service (Brazil Order Module)
    global static void webServiceLog(String request, String response, Integer statusCode, String className, String methodName, String recordId, String userId){
        
        Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Brazil').getRecordTypeId();
        
        Monitor_Log__c monObj = new Monitor_Log__c();
        monObj.RecordTypeId = recordTypeId;
        monObj.Module__c = className;
        monObj.Method__c = methodName;
        monObj.Request__c = request;
        monObj.Response__c = response;
        monObj.Status_Code__c = statusCode;
        monObj.Sales_Order__c = recordId;
        monObj.User__c = userId;
        upsert monObj;  
        
        DateTime d = DateTime.Now() ;
        String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
        System.debug(dateString);
        
        Attachment attObj = new Attachment();
        attObj.Name = 'Request '+dateString+'.log';
        attObj.Body = Blob.valueOf(request);
        attObj.ParentId = monObj.Id;
        insert attObj;
        
        
        Attachment attObj2 = new Attachment();
        attObj2.Name = 'Response '+dateString+'.log';
        attObj2.Body = Blob.valueOf(response);
        attObj2.ParentId = monObj.Id;
        insert attObj2;        
    }




   /*
    * @Description - This method call when SOR and DG integration classes sending request to server. 
    * @Param String - request,response,className,methodName,recordId,userId
    * @return  -    void
    */
    global static void webServiceLogDGSOR(String request, String response, Integer statusCode, String className, String methodName, String recordId, String userId){
        
        Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Brazil').getRecordTypeId();
        
        Monitor_Log__c monObj = new Monitor_Log__c();
        monObj.RecordTypeId = recordTypeId;
        monObj.Module__c = className;
        monObj.Method__c = methodName;
        monObj.Request__c = request;
        monObj.Response__c = response;
        monObj.Status_Code__c = statusCode;
        if(className=='DGUpdateStatusRealization' || className=='DGUpdateRejectStatusSap' || className=='DGFetchCreate' || className=='ServiceHelper' || className=='DGUpdateActualBudget'|| className=='DGCancelDemandStatus'){
            monObj.Demand_Generation__c = recordId;
            
        }
        else if(className=='SORIntegrationService')
        {
            monObj.Return_Sales_Order__c = recordId;
        }
        monObj.User__c = userId;
        upsert monObj;  
        
        DateTime d = DateTime.Now() ;
        String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
        System.debug(dateString);
        
        Attachment attObj = new Attachment();
        attObj.Name = 'Request '+dateString+'.log';
        attObj.Body = Blob.valueOf(request);
        attObj.ParentId = monObj.Id;
        insert attObj;
        
        Attachment attObj2 = new Attachment();
        attObj2.Name = 'Response '+dateString+'.log';
        attObj2.Body = Blob.valueOf(response);
        attObj2.ParentId = monObj.Id;
        insert attObj2;        
    }   

    /*
    * @Description - This method call when SOR and DG integration classes Fail and through exception. 
    * @Param String - request,recordId,className
    * @return  -    void
    */
    global static void exceptionHandlerSORandDG(Exception exObj,String recordId, String request,String response,String className){
        
        Monitor_Log__c monObj = new Monitor_Log__c();

        Id recordTypeId = Schema.SObjectType.Monitor_Log__c.getRecordTypeInfosByName().get('Brazil').getRecordTypeId();
        monObj.RecordTypeId = recordTypeId;
        if(exObj!=null){
            monObj.Line_Number__c = exObj.getLineNumber();
            monObj.Message__c = exObj.getMessage();
            monObj.Cause__c = String.valueOf(exObj.getCause());
            monObj.Stack_Trace__c = exObj.getStackTraceString();
            
            String trace = exObj.getStackTraceString().substringAfter('\n');
            monObj.Module__c = getClassName(trace);
            monObj.Method__c = getMethod(trace);
            monObj.Request__c=request;
            monObj.Response__c=response;
            
            if(className=='DGUpdateStatusRealization' || className=='DGUpdateRejectStatusSap' || className=='DGFetchCreate' || className=='ServiceHelper') {
                monObj.Demand_Generation__c = recordId;
            }
            else if(className=='SORIntegrationService') {
                monObj.Return_Sales_Order__c = recordId;
            }
            monObj.User__c = UserInfo.getUserId();
            
            upsert monObj;  
            
            if(exObj!=null){
                DateTime d = DateTime.Now() ;
                String dateString =  d.format('dd/MM/yyyy hh:mm a') ;
                System.debug(dateString);
                
                Attachment attObj3 = new Attachment();
                attObj3.Name = 'Exception '+dateString+'.log';
                attObj3.Body = Blob.valueOf(JSON.serialize(monObj));
                attObj3.ParentId = monObj.Id;
                insert attObj3;
            }
        }
    }
    



    
}