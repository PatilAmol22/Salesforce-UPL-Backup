/*
* Ticket : SCTASK0502048 
* Name: ReportExporterTurkey
* Description: Scheduled reports are fired for In-Transit Sales Orders
* Supporting Class: ReportExporterTurkeyTest (Test Class)
*/


global class ReportExporterTurkey implements System.Schedulable {
    global void execute(SchedulableContext sc) {
        DoExport();
    }
    
    @future(callout=true)
    public static void DoExport(){
        
        List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
        List<Report_Exporter__c> exportUpdateList = new List<Report_Exporter__c>{};
        List<Messaging.SingleEmailMessage> mailsForSampleOrders  = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> mailForDomesticOrders  = new List<Messaging.SingleEmailMessage>();
        List<Sales_Order__c > lstSampleSalesOrder = new List<Sales_Order__c >();
        List<Sales_Order__c > lstDomesticSalesOrder = new List<Sales_Order__c >(); 
        List<ID > lstOfIdsDomestic = new List<ID>();
        List<ID > lstOfIdsSample = new List<ID>();
        List<Sales_Order_Line_Item__c > lstDomesticSalesOrderItem = new List<Sales_Order_Line_Item__c >();
        List<Sales_Order_Line_Item__c > lstSampleSalesOrderItem = new List<Sales_Order_Line_Item__c >();
        //MAP<ID,List<Sales_Order_Line_Item__c>> mapSampleSalesOrderItem = new MAP<ID,List<Sales_Order_Line_Item__c>>();
        exportList = [Select Id, Name, Report_Id__c, Attachment_Name__c, Email_Subject__c, Email_Content__c, Email_Recipients__c,
                      Frequency__c from Report_Exporter__c WHERE  Type__c = 'Sales Order-Turkey'];
        
        lstSampleSalesOrder = [SELECT Id,Name,SFDC_Order_Number__c,Sales_District_Turkey__c,SoldtoPartySAPCode__c,Sold_to_Party__c,Order_Status__c FROM Sales_Order__c WHERE (SalesOrgCode__c='7110' AND (Order_Status__c ='In Transit' OR Order_Status__c ='Error from SAP') AND Order_Date__c = THIS_FISCAL_YEAR AND Order_Type_Code__c='ZTF0') LIMIT 49999];
        lstDomesticSalesOrder = [SELECT Id,Name,SFDC_Order_Number__c,Sales_District_Turkey__c,SoldtoPartySAPCode__c,Sold_to_Party__c,Order_Status__c FROM Sales_Order__c WHERE (SalesOrgCode__c='7110' AND (Order_Status__c ='In Transit' OR Order_Status__c ='Error from SAP') AND Order_Date__c = THIS_FISCAL_YEAR AND Order_Type_Code__c='ZTO0') LIMIT 49999];
        if(lstDomesticSalesOrder.size()>0){
            for(Sales_Order__c order : lstDomesticSalesOrder)
            {
                lstOfIdsDomestic.add(order.Id);
            }
        }
        if(lstSampleSalesOrder.size()>0){
            for(Sales_Order__c order : lstSampleSalesOrder)
            {
                lstOfIdsSample.add(order.Id);
            }
        }
        lstDomesticSalesOrderItem = [SELECT Id,Name,SKU_Name__c,SKU_Description__c,Sale_Order__c,Sale_Order__r.Sales_District_Turkey__c,Sale_Order__r.SFDC_Order_Number__c,Sale_Order__r.SoldtoPartySAPCode__c,Sale_Order__r.Sold_to_Party__r.Name,Sale_Order__r.Sold_to_Party__c,Sale_Order__r.OrderQuantity__c,Net_Price__c,Price__c,Sale_Order__r.Order_Status__c,Sale_Order__r.CreatedDate From Sales_Order_Line_Item__c where Sale_Order__c IN :lstOfIdsDomestic LIMIT 49999];
        lstSampleSalesOrderItem = [SELECT Id,Name,SKU_Name__c,SKU_Description__c,Sale_Order__c,Sale_Order__r.Sales_District_Turkey__c,Sale_Order__r.SFDC_Order_Number__c,Sale_Order__r.SoldtoPartySAPCode__c,Sale_Order__r.Sold_to_Party__r.Name,Sale_Order__r.Sold_to_Party__c,Sale_Order__r.OrderQuantity__c,Net_Price__c,Price__c,Sale_Order__r.Order_Status__c,Sale_Order__r.CreatedDate From Sales_Order_Line_Item__c where Sale_Order__c IN :lstOfIdsSample LIMIT 49999];
        /*if(lstDomesticSalesOrderItem.size() > 0){
            for(Sales_Order_Line_Item__c lineitem : lstDomesticSalesOrderItem)
            {
                if(mapSampleSalesOrderItem.containsKey(lineitem.Sale_Order__c))
                    mapSampleSalesOrderItem.get(lineitem.Sale_Order__c).add(lineitem);
                else{
                    mapSampleSalesOrderItem.put(lineitem.Sale_Order__c,new List<Sales_Order_Line_Item__c>{lineitem});
                }
            }
        }*/
        String header = 'Sales District,SFDC Order Number,Sold to Party SAP Code,Sold to Party,SKU Description,Order Quantity,Net Price,Value,Order Status,Created Date \n';
        String finalstr = header ;
        String finalstrsample = header ;
        if(lstDomesticSalesOrderItem.size()>0)
        {
            for(Sales_Order_Line_Item__c item : lstDomesticSalesOrderItem)
            {   Decimal SetPrice = item.Price__c.setScale(2);
                Decimal SetNetPrice = item.Net_Price__c.setScale(2);
                String recordString = item.Sale_Order__r.Sales_District_Turkey__c+','+item.Sale_Order__r.SFDC_Order_Number__c+','+item.Sale_Order__r.SoldtoPartySAPCode__c+','+item.Sale_Order__r.Sold_to_Party__r.Name+','+item.SKU_Description__c+','+item.Sale_Order__r.OrderQuantity__c+','+SetNetPrice+','+SetPrice+','+item.Sale_Order__r.Order_Status__c+','+item.Sale_Order__r.CreatedDate+'\n';     
                finalstr = finalstr +recordString;
            }
        }
        if(lstSampleSalesOrderItem.size()>0)
        {
            for(Sales_Order_Line_Item__c item : lstSampleSalesOrderItem)
            {
                Decimal SetPrice = item.Price__c.setScale(2);
                Decimal SetNetPrice = item.Net_Price__c.setScale(2);
                String recordString = item.Sale_Order__r.Sales_District_Turkey__c+','+item.Sale_Order__r.SFDC_Order_Number__c+','+item.Sale_Order__r.SoldtoPartySAPCode__c+','+item.Sale_Order__r.Sold_to_Party__r.Name +','+item.SKU_Description__c+','+item.Sale_Order__r.OrderQuantity__c+','+SetNetPrice+','+SetPrice+','+item.Sale_Order__r.Order_Status__c+','+item.Sale_Order__r.CreatedDate+'\n';     
                finalstrsample = finalstrsample +recordString;
            }
        }
        for(Report_Exporter__c e : exportList){
            //Determine if Exporter record is scheduled to run today.
            Boolean process = true;           
            //Run process if scheduled.
            if(process){
                System.debug('Starting message processing for: ' + e.Name);
                Blob content;
                Blob csvwithSemiColon;
                String csvwithcomma;
                String csvwithcommaSample;
                //ApexPages.PageReference report = new ApexPages.PageReference('/' + e.Report_Id__c + '?csv=1&exp=1&enc=UTF-8'); 
                if(!Test.isRunningTest()){
                //csvwithcomma =report.getContent().tostring();
                csvwithcomma=finalstr.replaceAll(',', ';');
                csvwithcommaSample = finalstrsample.replaceAll(',', ';');
                //keyencoded = EncodingUtil.urlEncode(csvwithcommaSample, 'UTF-8');
                if(e.Name == 'Sales Order Turkey - Sample')
                  csvwithSemiColon=Blob.valueOf(csvwithcommaSample);
                if(e.Name == 'Sample Order Turkey - Domestic')
                  csvwithSemiColon=Blob.valueOf(csvwithcomma);
                }                    
                content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : csvwithSemiColon; 
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(e.Attachment_Name__c);
                attachment.setBody(content);
                attachment.setContentType('text/csv');
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
                message.setSubject(e.Email_Subject__c);
                message.setPlainTextBody(e.Email_Content__c);
                String[] emailRecipients = e.Email_Recipients__c.split(',');
                message.setToAddresses(emailRecipients);
                if(e.Name == 'Sales Order Turkey - Sample')
                mailsForSampleOrders.add(message);
                else if(e.Name == 'Sample Order Turkey - Domestic')
                mailForDomesticOrders.add(message);   
                System.debug('Completed message processing for: ' + e.Name);
                exportUpdateList.add(e);
            }
        }
        //Send the email messages all at once to avoid limits.
        if(lstSampleSalesOrder.size()>0)
        Messaging.sendEmail(mailsForSampleOrders);
        if(lstDomesticSalesOrder.size()>0)
        Messaging.sendEmail(mailForDomesticOrders);    

        
        //Update Export record with Last Ran date.
        update exportUpdateList;
    }
}