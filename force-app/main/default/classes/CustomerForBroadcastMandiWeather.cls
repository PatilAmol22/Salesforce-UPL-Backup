global class CustomerForBroadcastMandiWeather implements Database.Batchable<sObject>,   Database.AllowsCallouts 
{   
    public static List<CustomerDetails> allAccount  = new List<CustomerDetails>();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select Account.Name, Account.PersonMobilePhone,Account.State_Language__pc from Account where SMS_Voice_Msg_Call_Consent__pc = \'Yes\' and Account.State_Language__pc = \'Marathi\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        for(Account a :scope){
            CustomerDetails cd = new CustomerDetails(a.Name,a.PersonMobilePhone,a.State_Language__pc);
            allAccount.add(cd);
        }
        system.debug('@@@'+allAccount);
        if(!allAccount.isEmpty()){
            system.debug('@@@In finish Method');
            sendWhatsapp();
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
        
    }
    
    
    public static void sendWhatsapp(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        List <Engagely_Settings__c> EngSet = Engagely_Settings__c.getall().values();
        String Username = EngSet[0].User_Name__c;
        String Password = EngSet[0].Password__c;
        String URL = EngSet[0].wrmsURL__c;
        request.setEndpoint(URL);
        //String strJSON = JSON.serialize(allAccount);
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeObjectField('user_list', allAccount);
        String jsonS = gen.getAsString();
        System.debug('@@'+jsonS);
        request.setbody(jsonS);
        String headerValue =EncodingUtil.base64Encode(Blob.valueOf(Username + ':' + Password));
        String authorizationHeader = 'Basic '+headerValue;
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response;
        if(!Test.isRunningTest()){
               response = http.send(request);
        }
        
    }
    class CustomerDetails{
        string name;
        Decimal mobile_number;
        String language;
        CustomerDetails(String n,String phone,string l){
            name = n;
            mobile_number = Decimal.valueOf(phone);
            language = l;
        }
    }
}