@isTest
public class DataUploadControllerTest {
    public static testMethod void method1(){
        Sales_Org__c salesOrg2= new Sales_Org__c();
        salesOrg2.Name='Chile';
        salesOrg2.Description__c='Chile';
        salesOrg2.Sales_Org_Code__c='5661';
        insert salesOrg2;
        
        SKU__c skuid = TestDataFactory.CreateSKU('6221205', salesOrg2, 'CL00566120302020-01-012020-12-31');
        Zone__c zn = new Zone__c();
        zn.Name='CL01';
        zn.ZoneCode__c='CL01';
        insert zn;
        
        Account acc = TestDataFactory.CreateAccount('1234567');
        acc.Account_Type__c = 'Sold To Party';
        update acc;
        
      
        
        String file = 'Conversion_Quantity__c,Distributor_Sales_Office_Code__c,Distributor_Sales_Office_Name__c,Distributor_SKU_Code__c,Distributor_SKU_Name__c,Distributor_UOM__c,Distributor_SAP_CODE,SKUCode__c,Unit_Price__c,UPL_Sales_Office_Code__c,Valid_from__c,Valid_To__c\n0.1,61003,BOD. MAL ESTADO,79438,MAXIM x 0.1 kg,EA,1234567,6221205,10,CL01,2020-01-01,2020-12-31';
        String returnString = DataUploadController.passFileAura(file, 'Distributor-SKU Mapping');
        String file2 = 'Distribution Channel,Division,SKU Code,UOM,Price,Start Date,End Date,Distributor SAP Code\n20,10,6221205,L,25,2020-01-01,2020-12-31,1234567\n';
		String returnString1 = DataUploadController.passFileAura(file2, 'Price Book');
        
        String returnStr = DataUploadController.getDocument();
         String returnStr1 = DataUploadController.getDocument1();
        
    }
}