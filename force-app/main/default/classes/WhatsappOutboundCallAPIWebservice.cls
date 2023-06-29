@RestResource(urlMapping='/OutboundCallAPI/*')
global class WhatsappOutboundCallAPIWebservice {
    @HttpPost
    global static void createRecord(String callType ,String phone) {
        try{
        if(phone != null){
            List<String> idList = new List<String>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = 'User of AKC who upload farmer'];
            for (GroupMember gm : gp.GroupMembers) {
                idList.add(gm.UserOrGroupId);
            }
            List<String> mailToAddresses = new List<String>();
            for(User u : [SELECT Email FROM User WHERE Id IN :idList])
            {
                mailToAddresses.add(u.email);
            }
            String emailBody = '<html><style>table, th, td {border-collapse: collapse;  border: 1px solid black;}</style><body> Hi ,<br/><br/>We recieved below farmer from bot.Kindly add below farmer into salesforce:<br/><br/><h4></h4><table><tr><th>Number</th><th>Source</th><th>Query</th></tr><tr><td>  '+phone+'  </td><td>  Whatsapp Bot  </td><td>  '+callType+'  </td></tr></table><br/><br/>Thanks</body></html>';
            mail.setToAddresses(mailToAddresses);
            mail.setSubject('Whatsapp Farmers to Upload in SFDC');
            mail.setHTMLbody(emailBody);
            List<Messaging.SendEmailResult> result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('@@'+result);
            if(!result[0].IsSuccess()){
                RestResponse response = RestContext.response;
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf('{ "Message" : "'+result[0].getErrors()+'" }');
                RestContext.response.statusCode = 400;
            }
            else{
                RestResponse response = RestContext.response;
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf('{ "Message" : "Success" }');
                RestContext.response.statusCode = 200;
            }
            
        }
        }catch(Exception e){
            System.debug('Error'+e);
        }
    }
}