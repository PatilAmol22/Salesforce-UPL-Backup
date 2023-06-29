global class FRContractEmailServiceClass implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
	 string body='', fromEmailId='';
        string[] bodyString;
		string comment;
		string uniqueContractNo;
        string subj =email.subject;
        string regex = '[a-zA-Z]{1,}|\\:';
        string cString = subj.replaceAll(regex, '');
        string cName = cString.replaceAll( '\\s+', '');
        string uName;
        string uString;
        list<string> approvalString = new list<string>{'APPROVE', 'APPROVED', 'YES'};
		list<string> rejectionString = new list<string>{'REJECT', 'REJECTED', 'NO'};

        try{
        if(email.plainTextBody!=null ) {  
           bodyString= email.plainTextBody.split('\n', 0);
           body = bodyString[0]; 
           comment = bodyString[1];  
           uName = bodyString[2];
           uString = uName.replaceAll(regex, ''); 
           uniqueContractNo = uString.replaceAll( '\\s+', '');
        }
		
        fromEmailId = email.fromAddress;
        Contract_management__c   contractQuery = new Contract_management__c();
            if(cName!=null){
            system.debug(cName);
		contractQuery = [select id,name,Status__c,Legal_Comments__c,Legal_Response_Date__c,Unique_Contract_Number__c,owner.email,Legal_Person_Email__c,Send_Email_To_Legal__c from Contract_management__c where name=:cName and Legal_Person_Email__c=:fromEmailId limit 1];
            }
	
        for(string a:approvalString){            
        if(body.contains(a) && contractQuery!=null){ 
            contractQuery.Status__c= system.label.France_Legal_Approved;
            contractQuery.Send_Email_To_Legal__c=false;  
			contractQuery.Unique_Contract_Number__c=uniqueContractNo;
            contractQuery.Legal_Response_Date__c=system.today();
            contractQuery.Legal_Comments__c=comment;
            }                   
        }
		
		for(string r:rejectionString){
        if(body.contains(r) && contractQuery!=null){
            contractQuery.Status__c= system.label.France_Legal_Rejected;
			contractQuery.Send_Email_To_Legal__c=false;	
            contractQuery.Unique_Contract_Number__c=uniqueContractNo;
            contractQuery.Legal_Response_Date__c=system.today();
            contractQuery.Legal_Comments__c=comment;
            }                   
        }
		      
        update contractQuery;
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            return result;
    }
}