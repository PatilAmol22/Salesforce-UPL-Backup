@isTest
public class ChatBot_CustomerOrder_Test {
	public static testmethod void chatbot_CustomerOrder(){
        
      
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_CustomerOrder.PrechatInput> inputParameters = new list<ChatBot_CustomerOrder.PrechatInput>();
        ChatBot_CustomerOrder.PrechatInput inputParameter = new ChatBot_CustomerOrder.PrechatInput();
        inputParameter.customerName ='abcd';
        inputParameter.userName ='abcd';
        inputParameters.add(inputParameter);
		ChatBot_CustomerOrder.getCustomersforOrder(inputParameters);
        //ChatBot_CustomerOrder.getOrderStatus('email@test.com','chirag');
         //ChatBot_CustomerOrder.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}