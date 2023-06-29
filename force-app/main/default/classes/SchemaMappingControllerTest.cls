@isTest
public class SchemaMappingControllerTest {
    //testing data setup for all methods in this class
    @testSetup
    static void allTheDataForThisTestClass() {
        Schema_Definition__c sdObj = new Schema_Definition__c();
        sdObj.Name = 'BusinessDashboardData__c';
        sdObj.Mapping_Definition__c = '[{"position": 0,"label": "Territory Code","fieldType": "STRING","column": "Territory\\t","api": "TerritoryCode__c"}, {"position": 2,"label": "PY Actual - MTD","fieldType": "DOUBLE","column": "\\tActual Sales FEB 2016\\t","api": "py_actual_mtd__c"}]';
        sdObj.File_Name__c = 'Business Dashboard Channel Partner';
        insert sdObj;

        //'[{"position": 0,"label": "Territory Code","fieldType": "STRING","column": "Territory\\t","api": "TerritoryCode__c"}, {"position": 2,"label": "PY Actual - MTD","fieldType": "DOUBLE","column": "\\tActual Sales FEB 2016\\t","api": "py_actual_mtd__c"}]'
    }
    
    static testMethod void method() {
        Schema_Definition__c sdobj = [SELECT id FROM Schema_Definition__c];
        //PageReference pageRef = Page.SchemaMapping;
        //Test.setCurrentPage(pageRef);
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(sdobj);
        SchemaMappingController smc = new SchemaMappingController();
        smc.selectedObject = 'BusinessDashboardData__c';
        smc.fileName = 'Business Dashboard Channel Partner';
        smc.header = 'Territory,Customer,ActualSalesFEB2016,ActualPYYTDFEB2016,ActualSalesFEB2017,ActualYTDFEB2017,%GrowthFEB2017,%GrowthYTDFEB2017,Row No';        
        smc.autoMap();
        smc.getApi();
        smc.importCSVFile();
        smc.setObject();
        smc.saveMapping();
        smc.redirectFunction();
    }
}