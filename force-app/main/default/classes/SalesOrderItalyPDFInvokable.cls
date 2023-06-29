/*
Name : vishal Pawar
Email : vishal_pawar@skinternational.com
Description: This class is calls from Process Builder once the Order Status gets open and Sales Org is Italy
*/


public  class SalesOrderItalyPDFInvokable {
    
    @InvocableMethod
    public static void ProcessSalesorder(List<Id> salesOrderIds){
        try{
            List<Attachment> attachList = new List<Attachment>();
            Attachment attach;
            MAP<String,Sales_Order__c> soMAp = new MAP<String,Sales_Order__c>();
            List<Sales_Order__c> soList = new List<Sales_Order__c>();
            soList = [select id, Name FROM Sales_Order__c WHERE ID IN:salesOrderIds];
            for(Sales_Order__c soObj : soList){
                soMAp.put(soObj.Id,soObj);
            }
            
            if(salesOrderIds.size()>0){
                for(String sId :salesOrderIds){
                    PageReference pdf = Page.SalesOrderItalyPDF;
                    pdf.getParameters().put('soid',sId);
                    
                    attach = new Attachment(); 
                    Blob body;
                    
                    if(Test.isRunningTest()) { 
                        body = blob.valueOf('Unit.Test'); 
                    } else {
                        body = pdf.getContent();
                    }
                    attach.Body = body; 
                    if(soMap.containsKey(sId)){
                        String nm = soMap.get(sId).Name;
                        attach.Name = nm+'.pdf';    
                        // attach.Name = 'Sales Order Italy '+Datetime.now().format('dd-MM-yyyy')+'.pdf';    
                    }
                    
                    attach.ParentId = sId;
                    attachList.add(attach);
                }
            }
            
            System.debug('size of Attach '+attachList.size());
            if(attachList.size()>0){
                insert attachList;
            }
        }
        catch(Exception ex){
            System.debug('Error Occure Line Number '+ex.getLineNumber());
            System.debug('Error Occure Message '+ex.getMessage());
        }
        
        
    }// end of ProcessSalesorder Method
}