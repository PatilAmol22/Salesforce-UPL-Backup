@isTest
public class ChatBot_getOrderSummaryBySalesDist_Test {
    public static testmethod void chatbot_getOrderSummaryBySalesDistrict(){
        Sales_District__c sd=new Sales_District__c();
        sd.Sales_District_Code__c='1234';
         sd.Name='Test';
        insert sd;
        
         EnglishSalesTeamChatbotSetting__c chatsetting = new EnglishSalesTeamChatbotSetting__c(Name = 'Eisenstein Connected App Setting',
         ConsumerKey__c ='3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJ',
         End_Point__c ='email@test.com',
         siteBase__c='https://test.salesforce.com');
         insert chatsetting;
        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorChatbot());
        list<ChatBot_getOrderSummaryBySalesDistrict.PrechatInput> inputParameters = new list<ChatBot_getOrderSummaryBySalesDistrict.PrechatInput>();
		ChatBot_getOrderSummaryBySalesDistrict.PrechatInput inputParameter=new ChatBot_getOrderSummaryBySalesDistrict.PrechatInput();
        inputParameter.sSD=sd;
        inputParameter.sUserName = 'abc@test.com';
        inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryBySalesDistrict.getOrderSummarySalesDistrictData(inputParameters);    
        
        inputParameters = new list<ChatBot_getOrderSummaryBySalesDistrict.PrechatInput>();
        inputParameter=new ChatBot_getOrderSummaryBySalesDistrict.PrechatInput();
        inputParameter.sSD=sd;
        inputParameter.sUserName = 'abc@test.com';
        inputParameters.add(inputParameter);
        ChatBot_getOrderSummaryBySalesDistrict.getOrderSummarySalesDistrictData(inputParameters);    
  
        //ChatBot_getOrderSummaryBySalesDistrict.getOrderSummary('email@test.com','Partially processed','123456');
        ChatBot_getOrderSummaryBySalesDistrict.getAccessToken('https://test.salesforce.com','3MVG959Nd8JMmavRSwlR5Gb2jnSckER71LcEIUP6TkU6c5.84TFYWEByi8.FZYj8ZXJGgytl5hzhGhGLtpOqw','email@test.com');
              
    }

}