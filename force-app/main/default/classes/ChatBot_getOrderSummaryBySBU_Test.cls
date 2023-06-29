@isTest
public class ChatBot_getOrderSummaryBySBU_Test {
	public static testmethod void chatbot_getOrderSummaryBySBU(){
        
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryBySBU.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryBySBU.PrechatInput>();
        ChatBot_getOrderSummaryBySBU.PrechatInput inputParameter = new ChatBot_getOrderSummaryBySBU.PrechatInput();
        SBU__c s= new SBU__c();
        //s.Name='Test';
        s.SBUCode__c ='1111';
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.SBU__c =s.Id;
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryBySBU.getOrderSummarySBUData(inputParameters);    
        
        inputParameters = new list<ChatBot_getOrderSummaryBySBU.PrechatInput>();
        inputParameter = new ChatBot_getOrderSummaryBySBU.PrechatInput();
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
		ChatBot_getOrderSummaryBySBU.getOrderSummarySBUData(inputParameters);    
        //ChatBot_getOrderSummaryByRegion.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryBySBU.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}