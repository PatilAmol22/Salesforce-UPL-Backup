@isTest
public class CaseProductTrigger_Test {
@isTest

    static void caseprod1(){
        Test.startTest();
    Sales_Org__c sorg=TestDataFactory.CreateSalesOrgCode();
        sorg.Sales_Org_Code__c='3100';
        update sorg;
        system.debug(sorg.Sales_Org_Code__c);
             Sales_Org__c sorg1 = [Select id, name,Sales_Org_Code__c from Sales_Org__c where id =:sorg.Id limit 1];
        test.stopTest();
        Division__C div=new division__c();
        div.name='75';
        div.division_code__c='75';
        insert div;
         Account acc = TestDataFactory.CreateAccount('spCode');
    acc.Name='ABC';
    acc.Mobile__c='9090909090';
    acc.Email__c='abc@mail.com';
    acc.Sales_Org__c=sorg.Id;
       acc.Division__c=div.Id;
    update acc;
        SKU__c sku=TestDataFactory.CreateSKU('Test123',sorg,'comb' );
    	sku.Product_Category__c='Herbicides';
    	sku.Name='Test1';
        sku.Division__c=div.id;
        sku.Market_Manager__c=Userinfo.getUserId();
        sku.isparent__c=true;
    	update sku;
        SKU__c sk=new sku__c();
        sk.SKU_Code__c='Test456';
        sk.Sales_Org__c=sorg1.ID;
        sk.Combination_Key__c ='comn123' ;
    	sk.Product_Category__c='Cereal Herbicides';
    	sk.Name='Test2';
        sk.Division__c=div.id;
        sk.Market_Manager__c=Userinfo.getUserId();
        sk.isparent__c=true;
    	insert sk;
        Case c=new case();
                Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSR').getRecordTypeId();

        c.RecordTypeId=RecordTypeIdCase;
        insert c;
        case_product__c cp=new case_product__c();
        cp.Case__c=c.id;
        cp.Brand_Pack_Size__c=sku.id;
        cp.Division__c=div.Id;
        insert cp;
        case_product__c cp1=new case_product__c();
        cp1.Case__c=c.id;
        cp1.Brand_Pack_Size__c=sk.id;
        cp.Division__c=div.Id;
        insert cp1;
        delete cp1;
    }
}