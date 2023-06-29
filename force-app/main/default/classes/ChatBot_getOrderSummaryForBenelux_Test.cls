@isTest
public class ChatBot_getOrderSummaryForBenelux_Test {
	public static testmethod void chatbot_getOrderSummaryForBenelux(){
        
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryForBenelux.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryForBenelux.PrechatInput>();
        ChatBot_getOrderSummaryForBenelux.PrechatInput inputParameter = new ChatBot_getOrderSummaryForBenelux.PrechatInput();
        
        Territory_Distributor__c td=new Territory_Distributor__c();
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryForBenelux.getOrderSummaryforBeNeLuxData(inputParameters);    
        
        inputParameters = new list<ChatBot_getOrderSummaryForBenelux.PrechatInput>();
        inputParameter = new ChatBot_getOrderSummaryForBenelux.PrechatInput();
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
		ChatBot_getOrderSummaryForBenelux.getOrderSummaryforBeNeLuxData(inputParameters);    
        //ChatBot_getOrderSummaryByRegion.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryForBenelux.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}