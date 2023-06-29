@isTest
public class SearchDemandGenerationClsTest {
    @isTest
    public static void getDemandGeneration() {
         Rebate_Contract__c reb=new Rebate_Contract__c();
            reb.Name='150';
            reb.Actual_Value__c=15;
            reb.Category_Code__c='1500';
            reb.Type__c='Cooper Up';
            insert reb;
         Demand_Generation__c dem=new Demand_Generation__c();
        	dem.Actual_Budget__c=151;
        	dem.Balance__c=692;
        	dem.Budget_Available__c=150;
        	dem.Contract_Number__c=reb.id;
        	dem.Credit_Letter__c='Yes';
            dem.Document_Number__c='12345';
        	dem.Error_Message__c='yes';
            
        	dem.Event_Name__c='Yes';
        	dem.Event_Type__c='Other';
            dem.EventTypeOtherRemark__c='college';
            dem.Important_Information__c='Yes';
            dem.Participate_Profile__c='Sales Person';
            dem.Payment_to_Supplier__c='No';
        	dem.Planned_Value__c=86;
        	dem.SAP_Document_Number__c='13654';
        	dem.Status__c='Pending';
        	dem.Sub_Status__c='Awaiting MKT Approval';
        	dem.Total_Value__c=158;
        	dem.Type__c='Cooper Up';
        	insert dem;
        RSOAndDGEndPoint__c endurl =new RSOAndDGEndPoint__c();
        endurl.Name='NamedCredentialUrl';
        endurl.EndPointUrl__c='https://example.com/example/test';
        insert endurl;
        
        RSOAndDGEndPoint__c  endPointurl=new RSOAndDGEndPoint__c();
        endPointurl.Name ='fetchbalanceurl';
        endPointurl.EndPointUrl__c='https://l4097-iflmap.hcisbp.eu1.hana.ondemand.com/http/Fetch_Balance_Budget_Brazil';
        insert endPointurl;
        
         Test.startTest();
          SearchDemandGenerationCls.getSearchDemandGeneration(reb.id);
          Test.stopTest();
    }
}