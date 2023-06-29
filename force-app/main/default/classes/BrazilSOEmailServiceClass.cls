global class BrazilSOEmailServiceClass implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        list<string> ContactEmail = new list<string>();
        list<Contact> contactList = new list<Contact>();
        boolean isFirstResponse;
        id accId; 
        string body='', fromEmailId='', bodyRow1='' ,bodyRow2;
        list<string> approvalString = new list<string>{'APROVAR','APROVADO','SIM'};
        list<string> rejectionString = new list<string>{'REJEITAR','REJEITADO','NÃO'};
        string[] bodyString;
        string subj =email.subject;
        string regex = '[a-zA-Z]{1,}|\\:';
        string soString = subj.replaceAll(regex, '');
        string soSpace = soString.replaceAll( '\\s+', '');
        //string soName = soSpace.replaceAll( '-', '');
        string sodash = soSpace.replaceAll( '-', '');
        string soc = sodash.replaceAll( 'ç', '');
        string soa = soc.replaceAll( 'ã', '');
        string soName = soa.replaceAll( 'í', '');
        system.debug('** Sales order subject -> ' +subj);
        system.debug('** Email plainTextBody -> ' +email.plainTextBody);
        system.debug(soName +'** Sales order name');
        if(email.plainTextBody!=null) { 
           bodyString= email.plainTextBody.split('\n', 0);
           bodyRow1 = bodyString[0];
           body = bodyRow1.toUppercase();
           //bodyRow2 = bodyString[1];
        }
        system.debug('** Sales body Row 1 : ' +body);
        //system.debug('** Sales body Row 2 : ' +bodyRow2);
        fromEmailId = email.fromAddress;
        system.debug('** fromEmailId -> ' +fromEmailId);
        
        Sales_Order__c   querySO = new Sales_Order__c();
        Sales_Order__c sales = new Sales_Order__c();
        try{
             if(soName!=null){
                 sales = [select id,name,Order_Status__c,SalesOrgCode__c,Sold_to_Party__r.id from Sales_Order__c where name=:soName limit 1];
                 accId = sales.Sold_to_Party__r.id;
             }
            system.debug('**Account Id -> ' +accId);
            
            for(account acnt:[SELECT Id,name, (SELECT Id,name,Email,Brazil_Approval_Contact__c FROM Contacts where Brazil_Approval_Contact__c=true) FROM Account where Id =:accId ]){
            If(acnt.Contacts.size()>0){
            system.debug('**Inside Contact list');
            contactList.addAll(acnt.Contacts);
                }
               }
             system.debug('**Contact list -> ' +contactList);

             for(contact cons : contactList){
             if(cons.Brazil_Approval_Contact__c==true){
             ContactEmail.add(cons.Email);
                      }
                      }
            system.debug('**Contact Emails -> ' +ContactEmail);
              
            
         if(ContactEmail.contains(fromEmailId) && soName!=null){
		 system.debug('** Inside if fromEmailId in ContactEmail ');
        querySO = [select id,name,Order_Status__c,Brazil_Customer_Approval_Status__c,owner.email from Sales_Order__c where name=:soName limit 1];
        }
		
		
		system.debug('** Sales order is already approved ->  ' +querySO.Brazil_Customer_Approval_Status__c);
		
        for(string a:approvalString){
        if(body.contains(a) && querySO!=null && querySO.Brazil_Customer_Approval_Status__c==null){
            system.debug('** Inside Approval If');
            querySO.Brazil_Customer_Approval_Status__c= 'Approved';
            }                   
        }
		
		 for(string r:rejectionString){
        if(body.contains(r) && querySO!=null && querySO.Brazil_Customer_Approval_Status__c==null){
            system.debug('** Inside Rejection If');
            querySO.Brazil_Customer_Approval_Status__c= 'Rejected';
            }                   
        }
        
        update querySO;
        system.debug('** Updated Sales order : ' +querySO);
        }
        catch(Exception ex){
            System.debug('Line No: '+ex.getLineNumber()+' Message: '+ex.getMessage()+' Cause: '+ex.getCause());
        }
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            return result;
    }
}