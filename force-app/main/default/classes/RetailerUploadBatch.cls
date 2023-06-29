global class RetailerUploadBatch implements Database.batchable<String>, Database.Stateful
{
    
    String m_csvFile;
    Integer execution=0;
    list<RetailerUploadController.returnWrapper> masterwrap = new list<RetailerUploadController.returnWrapper>();
    Integer isSuccess=0;
          Integer isErr=0;
          String successString;
          String errString;
          String sub;
          String body;
	public RetailerUploadBatch(String csv)
    {
        m_csvFile= csv;
    }

	global Iterable<String> start(Database.batchableContext batchableContext){
        System.debug('m_csvFile 2:--'+m_csvFile);
        return new CSVIterator(m_csvFile, Parser.crlf);
    }


	global void execute(Database.BatchableContext batchableContext, List<String> scope){
        try{
            String csvFile = '';
            if (execution!=0)
            {
            csvFile='\r\n';
            }
                for(String row : scope){
                csvFile += row + Parser.crlf;
            }  
            system.debug('masterwrap'+masterwrap.size());
            RetailerUploadController.returnWrapper wrap = RetailerUploadController.passFile(csvFile);
            masterwrap.add(wrap);
            execution++;
            //masterwrap.addAll(wrap);
            system.debug('masterwrapout'+masterwrap.size());
        }
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
        }
    }
      global void finish(Database.BatchableContext batchableContext){
          system.debug('masterwrapfin'+masterwrap.size());
          if(masterwrap.size()>0){
              for(RetailerUploadController.returnWrapper m:masterwrap){
                  if(!m.returnValue.contains('success')){
                      
                      isErr+=1;
                     //system.debug(m.succ.length()+'succ');
                     //system.debug(m.err.length()+'err'+isErr);
                      if(m.succ!=null){
                      successString+=m.succ;
                      }
                      if(m.err!=null){
                      errString+=m.err;
                      }
                      sub=m.sub;
                      body=m.mailbody;
                  }
                  else if(m.returnvalue.contains('success')){
                      if(m.succ!=null){
                      successString+=m.succ;
                      }
                      if(m.err!=null){
                      errString+=m.err;
                      }
                  }
                  else if(m.returnvalue.contains('error')){
                      isErr+=1;
                      if(m.err!=null){
                      errString+=m.err;
                      }
                      if(m.succ!=null){
                      successString+=m.succ;
                      }
                  }
              }
          }
          system.debug('successString'+successString);
          system.debug('errString'+errString);
          if(isErr>0){
              system.debug('hell');
              List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
			Messaging.EmailFileAttachment csvsuccessAttc = new Messaging.EmailFileAttachment();
                if(successString!=null){
				blob csvsuccessBlob = Blob.valueOf(successString);
				string csvsuccessname= 'RetailerSuccess.csv';
				csvsuccessAttc.setFileName(csvsuccessname);
				csvsuccessAttc.setBody(csvsuccessBlob);
				efaList.add(csvsuccessAttc);
                }
				String loggedInUser= UserInfo.getUserEmail();
				system.debug('email value is '+ loggedInUser);
				
				Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                if(errString!=null){
				blob csvBlob = Blob.valueOf(errString);
				string csvname= 'RetailerError.csv';
				csvAttc.setFileName(csvname);
				csvAttc.setBody(csvBlob);
				efaList.add(csvAttc);
                }
				Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
				String[] toAddresses = new list<string> {loggedInUser};
					//String subject =Label.RU_email_Subject;
				email.setSubject(sub);
				email.setToAddresses( toAddresses );
				email.setPlainTextBody(body);
				email.setFileAttachments(efaList);
				Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          }
          else{
              List<Messaging.Emailfileattachment> efaList = new List<Messaging.Emailfileattachment>();
            String loggedInUser= UserInfo.getUserEmail();
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
			String[] toAddresses = new list<string> {loggedInUser};
			String subject =Label.SSF_email_Subject;
			email.setSubject('Batch Upload Completed');
			email.setToAddresses( toAddresses );
			email.setPlainTextBody('Batch processing of retailer upload completed');
				email.setFileAttachments(efaList);
				Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});         
}
          }
         
}