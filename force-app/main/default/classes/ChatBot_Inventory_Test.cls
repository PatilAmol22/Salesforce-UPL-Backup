@isTest
public class ChatBot_Inventory_Test {
    public static testmethod void chatbot_Inventory_Test(){
        ZUDL_ZUIC_C03_Q001__x externalObj=new ZUDL_ZUIC_C03_Q001__x();
        externalObj.BRAND__c='testBrand';
        externalObj.COMP_CODE__c='100';
        externalObj.PLANT_CODE__c='pc01';
        externalObj.COMP_DESC__c='testCompDesc';
        externalObj.QTY__c=10;
        externalObj.UOM__c='kg';
        externalObj.PLANT_DESC__c='testPlantDesc';
        //insert externalObj;
        
        Depot__c depo=new Depot__c();
        depo.Name='depo1';
        depo.Depot_Code__c='d0123';
        insert depo;
        
        Zone_Depot_Mapping__c zdm=new Zone_Depot_Mapping__c();
        zdm.Depot__c=depo.Id;
        insert zdm;
        
        //List<ChatBot_Inventory.PrechatInput> inputParam=new List<ChatBot_Inventory.PrechatInput>();
        //inputParam. sBrandName='testBrand';
        //inputParam.tmDepoMapRec=zdm;
        
        Test.startTest();
        List<ChatBot_Inventory.PrechatInput> inputParam=new List<ChatBot_Inventory.PrechatInput>();
        ChatBot_Inventory.getBrandData(inputParam);
        Test.stopTest();
            
    }
}