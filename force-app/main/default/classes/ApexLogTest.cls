@isTest
public class ApexLogTest {
    static testMethod void methodExceptionHandler(){
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Apex log Exception Coverage for India/Indonesia/SWAL/Argentina/Mexico');
            throw e;
        }
        catch(Exception ex){
            ApexLog.exceptionHandler(ex, null, null);
              ApexLog.KYCExceptionHandler(ex,null);
        }
    }
    
    
    static testMethod void methodexceptionHandlerForSalesOrder(){
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Apex log Exception Coverage for India/Indonesia/SWAL/Argentina/Mexico');
            throw e;
        }
        catch(Exception ex){
            ApexLog.exceptionHandlerForSalesOrder(ex, null, null);
        }
    }
    
    
    
    
    static testMethod void methodExceptionCoverage(){    
        try{
            ApexLog.exceptionCoverage(true);
        }
        catch(Exception ex){
            
        }
    }
    
    static testMethod void methodExceptionHandlerBrazil(){
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Apex log Exception Coverage for Brazil');
            throw e;
        }
        catch(Exception ex){
            Sales_Order__c soObj = new Sales_Order__c();
            ApexLog.exceptionHandlerBrazil(ex, null, soObj, 'Test');
        }
    }
    
    static testMethod void methodExceptionHandlerColumbia(){
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Apex log Exception Coverage for Brazil');
            throw e;
        }
        catch(Exception ex){
            Sales_Order__c soObj = new Sales_Order__c();
            ApexLog.exceptionHandlerColumbia(ex, null, soObj, 'Test');
        }
    }
        
        static testMethod void methodExceptionHandlerItaly(){
            try{
                CalloutException e = new CalloutException();
                e.setMessage('?Apex log Exception Coverage for Brazil');
                throw e;
            }
            catch(Exception ex){
                Sales_Order__c soObj = new Sales_Order__c();
                ApexLog.exceptionHandlerItaly(ex, null, soObj, 'Test');
            }
        }
    
   
    
    
    
    static testMethod void methodwebServiceLog(){
        ApexLog.webServiceLog('', '', 200, 'BrazilHANAServiceHelper', 'pushSalesOrder', null, null);
    }
    
    // SKI-Prashant Kumbhar--24/03/2023
    static testMethod void dGandSORwebServiceLog(){
        ApexLog.webServiceLogDGSOR('', '', 200, 'DGUpdateStatusRealization', 'UpdateStatus', null, null);
    }
    //SKI-Prashant Kumbhar--24/03/2023
    static testMethod void methodExceptionHandlerDGandSOR(){
        try{
            CalloutException e = new CalloutException();
            e.setMessage('?Apex log Exception Coverage for DG and SOR');
            throw e;
        }
        catch(Exception ex){
       ApexLog.exceptionHandlerSORandDG(ex, null, null,null,'SORIntegrationService');
        }
    }
    
    
    
    
}