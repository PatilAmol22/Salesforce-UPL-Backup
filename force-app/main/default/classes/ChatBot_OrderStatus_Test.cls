@isTest
public class ChatBot_OrderStatus_Test {
    
     public static testmethod void chatbot_orderStatus(){
        
       
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_OrderStatus.PrechatInput> inputParameters = new list<ChatBot_OrderStatus.PrechatInput>();
        ChatBot_OrderStatus.PrechatInput inputParameter = new ChatBot_OrderStatus.PrechatInput();
        inputParameter.orderNumber ='1234';
        inputParameter.userName = 'abc@test.com';
         inputParameters.add(inputParameter);
		ChatBot_OrderStatus.getCustomersforOrder(inputParameters);    
        ChatBot_OrderStatus.getOrderStatus('email@test.com','123456');
         ChatBot_OrderStatus.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }

}