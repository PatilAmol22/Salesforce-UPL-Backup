@isTest
public class ChatBot_GetCustomerOrderDetails_Test {
	public static testmethod void chatbot_orderStatus(){
        
       
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_GetCustomerOrderDetails.PrechatInput> inputParameters = new list<ChatBot_GetCustomerOrderDetails.PrechatInput>();
        ChatBot_GetCustomerOrderDetails.PrechatInput inputParameter = new  ChatBot_GetCustomerOrderDetails.PrechatInput();
        
        JSON2Apex.Records rec = new JSON2Apex.Records();
        rec.SAP_Code='1234';
        inputParameter.orderStatus='Open Orders';
        inputParameter.Acc = rec;//SAP_Code
		inputParameter.userName = 'abc@test.com';
        inputParameters.add(inputParameter);
		ChatBot_GetCustomerOrderDetails.getCustomerOrderListData(inputParameters);
        inputParameters = new list<ChatBot_GetCustomerOrderDetails.PrechatInput>();
        inputParameter = new  ChatBot_GetCustomerOrderDetails.PrechatInput();
        inputParameter.orderStatus='Dispatched Orders';
        inputParameter.Acc = rec;//SAP_Code
		inputParameter.userName = 'abc@test.com';
          inputParameters.add(inputParameter);
        ChatBot_GetCustomerOrderDetails.getCustomerOrderListData(inputParameters);    
        //ChatBot_GetCustomerOrderDetails.getOrderStatus('email@test.com','Partially processed','123456');
          //ChatBot_GetCustomerOrderDetails.getOrderStatus('email@test.com','Partially processed','123456');
         ChatBot_GetCustomerOrderDetails.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}