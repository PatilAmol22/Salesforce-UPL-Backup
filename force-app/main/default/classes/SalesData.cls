global class SalesData implements Messaging.InboundEmailHandler{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
         
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try
        {
            List<List<String>> combinedCSV = new List<List<String>>();
            list<String> csv= new list<string>();
            String emailSubject = email.Subject; 
            emailSubject = emailSubject.substring(emailSubject.indexOf(':') + 1);
            //System.debug('emailSubject:'+emailSubject);
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0 ) {
                for (Integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                    if(email.binaryAttachments[i].filename.endsWith('.txt')||email.binaryAttachments[i].filename.endsWith('.csv')){
                        csv= FileUtilitySalesData.processAttachment(email.binaryAttachments[i].filename, email.fromAddress, emailSubject, email.binaryAttachments[i].body);
                       combinedCSV.add(csv);
                    }
                }
            }
            //for text files
            if (email.TextAttachments != null && email.TextAttachments.size() > 0) {
                for (Integer i = 0 ; i < email.TextAttachments.size() ; i++) {
                    if(email.TextAttachments[i].filename.endsWith('.txt')||email.TextAttachments[i].filename.endsWith('.csv')){
                         csv= FileUtilitySalesData.processAttachment(email.TextAttachments[i].filename, email.fromAddress, emailSubject, Blob.valueOf(email.TextAttachments[i].body));
                    }
                }
                        }
            system.debug('csv size is '+ csv.size());
            Integer columncount;
            
            for(Integer i= 0;i<combinedCSV.size();i++)
            {
            for (Integer j= 0 ;j<combinedCSV[i].size();j++)
            {
            list<String> lst = new list<String>();
            lst=combinedCSV[i];
            //added on 30 april 2020
            list<string> column= new list<string>();
            column= lst[j].split('\r\n');
            column= column[0].split(',');
            columncount = column.size();
                   
            SalesDataReadandPopulateBatch batch = new SalesDataReadandPopulateBatch(lst[j],email.fromAddress,columncount); 
			database.executeBatch(batch,2000);
            }
            }
        return result;
    }  
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
        
        System.debug('result: '+result);
        return result;
    }
}