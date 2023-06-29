@isTest
public class ChatBot_getOrderSummaryByZone_Test {
	public static testmethod void chatbot_getOrderSummaryByZone(){
        
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryByZone.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryByZone.PrechatInput>();
        ChatBot_getOrderSummaryByZone.PrechatInput inputParameter = new ChatBot_getOrderSummaryByZone.PrechatInput();
        Zone__c z=new Zone__c();
        z.Name='test';
        z.ZoneCode__c='1234';
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.Zone__c=z.Id;
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryByZone.getOrderSummaryZoneData(inputParameters);   
        
        inputParameters = new list<ChatBot_getOrderSummaryByZone.PrechatInput>();
        inputParameter = new ChatBot_getOrderSummaryByZone.PrechatInput();
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
		ChatBot_getOrderSummaryByZone.getOrderSummaryZoneData(inputParameters);    
        //ChatBot_getOrderSummaryByZone.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryByZone.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}