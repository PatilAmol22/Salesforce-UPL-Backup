@isTest
public class ChatBot_getOrderSummaryByTerritory_Test {
	public static testmethod void chatbot_getOrderSummaryByTerritory(){
        
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryByTerritory.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryByTerritory.PrechatInput>();
        ChatBot_getOrderSummaryByTerritory.PrechatInput inputParameter = new ChatBot_getOrderSummaryByTerritory.PrechatInput();
        
        Territory_Distributor__c td = new Territory_Distributor__c();
        td.TerritoryCode__c='1234';
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryByTerritory.getOrderSummaryTerritoryData(inputParameters);    
        
        inputParameters = new list<ChatBot_getOrderSummaryByTerritory.PrechatInput>();
        inputParameter = new  ChatBot_getOrderSummaryByTerritory.PrechatInput();
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
		ChatBot_getOrderSummaryByTerritory.getOrderSummaryTerritoryData(inputParameters);    
        //ChatBot_getOrderSummaryByTerritory.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryByTerritory.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}