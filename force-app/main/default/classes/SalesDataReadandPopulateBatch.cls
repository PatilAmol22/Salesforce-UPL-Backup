global class SalesDataReadandPopulateBatch implements Database.batchable<String>, Database.Stateful {
     public class errorWrapper {
        @AuraEnabled
        public string SKUID {get;set;}
        @AuraEnabled
        public String customerID {get;set;}
        @AuraEnabled
        public String reason {get;set;}     
    }
    
    
    list<errorWrapper> masterwrap = new list<errorWrapper>();
    String m_csvFile;
    String address;
    Integer columncount;
    public SalesDataReadandPopulateBatch(String csv,String fromAddress,Integer count)
    {
        m_csvFile= csv;
        address=fromAddress;
        columncount=count;
    }
     global Iterable<String> start(Database.batchableContext batchableContext){
        System.debug('m_csvFile 2:--'+m_csvFile);
        return new CSVIterator(m_csvFile, Parser.crlf);
    }
    
    global void execute(Database.BatchableContext batchableContext, List<String> scope){
        try{
            String csvFile = '';
            list<errorWrapper> wrap = new list<errorWrapper>();
            System.debug('scope size is: '+scope.size());
            
            for(String row : scope){
                csvFile += row + Parser.crlf;
            }
            if (columncount==8)
            {
            wrap=FileUtilitySalesData.processSalesData(csvFile);
            masterwrap.addAll(wrap);
            }
            else
            {
            wrap=FileUtilitySalesData.processSalesDataShipTo(csvFile);
            masterwrap.addAll(wrap);
                
            }
            }
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
        }
    }
      global void finish(Database.BatchableContext batchableContext){
          
          
           if (masterwrap.size()>0)
                {
                    List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
                   
                    string header = 'Customer, SKU , Error Reason \n';
                    string finalstr = header ;
                    for(errorWrapper a: masterwrap)
                    {
                        string recordString = '"'+a.customerID+'","'+a.SKUID+'","'+a.reason+'" \n';
                        finalstr = finalstr +recordString;
                    }
                    
                   Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                    blob csvBlob = Blob.valueOf(finalstr);
                    string csvname= 'bw_sales_data_load_error.csv';
                    csvAttc.setFileName(csvname);
                    csvAttc.setBody(csvBlob);
                    efaList.add(csvAttc);
                    Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
                    String[] toAddresses = new list<string> {address};
                        String subject ='BW Sales Data Load Error';
                    email.setSubject(subject);
                    email.setToAddresses( toAddresses );
                    email.setPlainTextBody('Attached records are errored out');
                    email.setFileAttachments(efaList);
                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                }
         
          
}
}