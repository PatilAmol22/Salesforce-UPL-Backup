@isTest
public class ChatBot_getOrderSummaryByRegion_Test {
	public static testmethod void chatbot_getOrderSummaryByRegion(){
        
         
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryByRegion.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryByRegion.PrechatInput>();
        ChatBot_getOrderSummaryByRegion.PrechatInput inputParameter = new ChatBot_getOrderSummaryByRegion.PrechatInput();
        Region__c r= new Region__c();
        r.Name='Test';
        r.RegionCode__c='1111';
        Territory_Distributor__c td=new Territory_Distributor__c();
        td.Region__c=r.Id;
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryByRegion.getOrderSummaryRegionData(inputParameters);    
        
        inputParameters = new list<ChatBot_getOrderSummaryByRegion.PrechatInput>();
        inputParameter = new ChatBot_getOrderSummaryByRegion.PrechatInput();
        inputParameter.sTD = td;//Territory_Code
		inputParameter.sUserName = 'abc@test.com';
		inputParameters.add(inputParameter);
		ChatBot_getOrderSummaryByRegion.getOrderSummaryRegionData(inputParameters);    
        //ChatBot_getOrderSummaryByRegion.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryByRegion.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }
}